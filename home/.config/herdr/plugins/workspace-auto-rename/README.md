# Workspace Auto Rename (herdr plugin)

workspace の label を cwd に合わせて付け直す plugin。ghq root (`ghq root`、無ければ `~/ghq`) 配下の
リポジトリなら **`org/repo`**、それ以外は herdr の自動命名と同じ **ディレクトリ名** (ホームは `~`) にする。

label は `herdr workspace rename` で変えるため、サイドバーの Spaces / Agents 行だけでなく
`window_title` の `{workspace}` にも同じ名前が反映される。

## 判定ルール

| cwd | label |
|-----|-------|
| `<ghq root>/<host>/<org>/<repo>` (サブディレクトリ含む) | `org/repo` |
| 上記リポジトリの git worktree (checkout が ghq root 外でも可) | `org/repo` (`git rev-parse --git-common-dir` で元リポジトリを辿る) |
| それ以外 | ディレクトリ名 (ホームは `~`) |

現在の label が何であっても cwd から決めた label に付け直す。`workspace create --label` や `rename_workspace`
で付けた名前も次の実行タイミングで上書きされるので、名前を自分で付けない運用が前提。

同じリポジトリの worktree を複数開くと label が同じ `org/repo` になる。ブランチはサイドバーの
`branch` 行で見分ける想定。

## 実行タイミング

- **workspace 作成時** — `workspace.created`
- **worktree 作成 / オープン時** — `worktree.created` / `worktree.opened`
- **workspace / tab / pane フォーカス時** — `workspace.focused` / `tab.focused` / `pane.focused`
- **サーバ起動 / live handoff 後** — `[[startup]]` で全 workspace に適用
- **手動** — action `Rename workspace from cwd` (フォーカス中の workspace)

herdr は pane の cd に追従して label を付け直すが、そのときイベントを出さない。また一度 rename された
workspace の cd 追従をやめる。そのため cd 直後には反映されず、次にフォーカスが動いたときに付け直される。
すぐ反映したいときは手動 action を使う。

## 構成

| ファイル | 役割 |
|----------|------|
| `herdr-plugin.toml` | マニフェスト (events / actions / startup) |
| `lib.js` | 共通ロジック (ghq root 解決・元リポジトリの特定・rename) |
| `rename.js` | 単一 workspace の付け直し。event / action フックから起動 |
| `rename-all.js` | 全 workspace の付け直し。startup フックから起動 |

`node` / `git` / `herdr` を PATH で解決する。`ghq` は任意 (無ければ `~/ghq` を root とみなす)。

## セットアップ

```sh
# dotfiles 配下の plugin をまとめて link する
make link-herdr-plugins
# または個別に
herdr plugin link ~/.config/herdr/plugins/workspace-auto-rename --enabled
herdr plugin list
```

## 動作確認

```sh
# フォーカス中 workspace を手動で付け直す
herdr plugin action invoke rename --plugin workspace-auto-rename
# 実行ログ (exit_code / stderr)
herdr plugin log list
# label を確認
herdr workspace list
```
