# PR Status (herdr plugin)

各 workspace の git ブランチに紐づく GitHub の **PR 番号** と **CI ステータス** を取得し、
herdr のサイドバー (workspace リスト) に表示専用メタデータ (`tokens`) として反映する plugin。

取得には `gh` を使い、接続先は cwd の git remote から自動判定する。ホスト名はハードコードして
いないため、`gh` が認証済みのホストであればそのまま動く。

## 表示

workspace ごとに PR 番号と、CI 状態に応じた 1 つのトークンをセットする。CI は色を変えるため
状態別トークンに出し分けており、常にどれか 1 つだけに値が入る。

| token | 記号 | 意味 |
|-------|------|------|
| `PR` | `PR #1234` | ブランチに紐づく PR 番号。無ければクリア |
| `CI_OK` | `✓` | 全チェック成功 |
| `CI_FAIL` | `✗` | 失敗あり |
| `CI_PENDING` | `●` | 実行中・保留 |
| `CI_MERGED` | `merged` | PR マージ済み |
| `CI_CLOSED` | `closed` | PR クローズ済み (未マージ) |

サイドバーでの色付けは `config.toml` の `[ui.sidebar.spaces]` で各トークンに `fg` を割り当てて
行う (下記セットアップ参照)。

## 構成

| ファイル | 役割 |
|----------|------|
| `herdr-plugin.toml` | マニフェスト (actions / events / startup) |
| `lib.js` | 共通ロジック (gh 取得・rollup 集約・report-metadata) |
| `refresh.js` | 単一 workspace 更新。action / event フックから起動 |
| `refresh-all.js` | 全 workspace 更新。startup フックから起動 |

`node` / `git` / `gh` / `herdr` を PATH で解決するだけで、OS 依存のパスは持たない
(macOS / Linux 両対応)。

## 更新タイミング

- **workspace フォーカス時** — `workspace.focused` フックで取得 (workspace を切り替えるたび)
- **workspace / worktree 作成時** — `workspace.created` / `worktree.created` フックで取得
- **worktree オープン時** — `worktree.opened` フックで取得
- **サーバ起動 / live handoff 後** — `[[startup]]` フックで全 workspace を復元
- **手動** — action `Refresh PR/CI status` (フォーカス中の workspace)

`workspace.focused` を高速に繰り返しても gh 呼び出しが連打されないよう、イベント起動には
30 秒の短時間キャッシュを効かせている (同一 workspace + branch は 30 秒以内なら再取得しない。
branch が変われば即再取得)。手動 action はキャッシュを無視して常に最新を取得する。

herdr のイベントフックにはタイマーが無いため、CI の進行 (pending → ok/fail) 中に同じ workspace を
見続けている場合は自動追従しない。最新化したいときは手動 action を実行する。

## セットアップ

```sh
# 1. plugin を link (dotfiles 配下のこのディレクトリを指す)
herdr plugin link ~/.config/herdr/plugins/pr-status --enabled
herdr plugin list

# 2. gh が対象ホストに認証済みであること (このプラグインは gh pr view を使う)
gh auth status
#   失効していれば: gh auth refresh -h <host>
```

### サイドバーの表示設定 (config.toml)

`[ui.sidebar.spaces]` の `rows` にトークンを並べる。カスタムトークンは `$名前`、色を付ける場合は
`{ token = "$名前", fg = "#RRGGBB" }` 形式 (カスタムトークンでも `token` の値は `$` 始まり)。

```toml
[ui.sidebar.spaces]
rows = [
  ["state_icon", "workspace"],
  ["branch"],
  [
    "$PR",
    { token = "$CI_OK", fg = "#a6e3a1" },
    { token = "$CI_FAIL", fg = "#f38ba8" },
    { token = "$CI_PENDING", fg = "#f9e2af" },
    { token = "$CI_MERGED", fg = "#cba6f7" },
    { token = "$CI_CLOSED", fg = "#f38ba8", dim = true },
  ],
]
```

## 動作確認

```sh
# フォーカス中 workspace を手動更新
herdr plugin action invoke refresh --plugin pr-status
# 実行ログ (exit_code / stderr)
herdr plugin log list
# token が入ったか確認
herdr workspace get <workspace_id>   # workspace_id は `herdr workspace list` で確認
```

## 注意

- `gh pr view <branch>` は cwd のリポジトリの remote が指すホストに問い合わせる。認証切れ・未ログイン・
  PR 無し・非 GitHub リポジトリは全て「PR 無し」として token をクリアする (クラッシュしない)。未ログイン
  時は gh がローカルで即失敗するだけで、ネットワークへのリクエストは発生しない。
- token は `--ttl-ms` 付き (既定 15 分) で登録するため、更新が途切れると自動的に消える。手動更新
  のみの運用では、しばらく操作しないと表示が消えることがある。
- 連打抑制のキャッシュは `HERDR_PLUGIN_STATE_DIR` (plugin 専用の state ディレクトリ) に
  `fetch-<workspace_id>.json` として保存する。削除しても次回取得で作り直されるだけで害はない。
- workspace の cwd は herdr の context もしくは `pane list` のフォーカス pane から解決する。
