"use strict";

// git ブランチに紐づく PR 番号と CI ステータスを gh で取得し、herdr の workspace メタデータ
// (tokens) として反映する共通ロジック。接続先は gh が cwd の remote から判定する。

const { spawnSync } = require("node:child_process");
const fs = require("node:fs");
const path = require("node:path");

const SOURCE = "pr-status";
// token の TTL。更新が途切れたら自動的に消えるよう短めにする。
const DEFAULT_TTL_MS = 15 * 60 * 1000;
// 同一 workspace+branch の再取得を抑制する期間 (workspace.focused の連打対策)。
const FETCH_CACHE_TTL_MS = 30 * 1000;

const herdrBin = process.env.HERDR_BIN_PATH || "herdr";
const stateDir = process.env.HERDR_PLUGIN_STATE_DIR || null;

// herdr <args...> を実行し stdout を返す。失敗時は null (呼び出し側で握りつぶす)。
function herdr(args) {
  const r = spawnSync(herdrBin, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] });
  if (r.status !== 0 || !r.stdout) return null;
  return r.stdout;
}

// herdr の socket API は {"id":...,"result":{...}} 形式の JSON を返す。
function herdrJson(args) {
  const out = herdr(args);
  if (!out) return null;
  try {
    return JSON.parse(out).result ?? null;
  } catch {
    return null;
  }
}

// cwd で git のカレントブランチ名を取得する。detached HEAD やリポジトリ外なら null。
function currentBranch(cwd) {
  const r = spawnSync("git", ["-C", cwd, "symbolic-ref", "--quiet", "--short", "HEAD"], {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "ignore"],
  });
  if (r.status !== 0) return null;
  const branch = r.stdout.trim();
  return branch || null;
}

// statusCheckRollup を集約して CI の種別を返す。
// FAILURE があれば "fail"、未完了があれば "pending"、全て成功なら "ok"、チェックが無ければ null。
function rollupKind(rollup) {
  if (!Array.isArray(rollup) || rollup.length === 0) return null;

  let hasFailure = false;
  let hasPending = false;

  for (const check of rollup) {
    // CheckRun は status/conclusion、StatusContext は state を持つ。
    const conclusion = (check.conclusion || "").toUpperCase();
    const status = (check.status || "").toUpperCase();
    const state = (check.state || "").toUpperCase();

    if (["FAILURE", "TIMED_OUT", "CANCELLED", "ACTION_REQUIRED", "STARTUP_FAILURE", "ERROR"].includes(conclusion) ||
        ["FAILURE", "ERROR"].includes(state)) {
      hasFailure = true;
    } else if (status && status !== "COMPLETED") {
      // QUEUED / IN_PROGRESS / PENDING など
      hasPending = true;
    } else if (state === "PENDING" || state === "EXPECTED") {
      hasPending = true;
    }
  }

  if (hasFailure) return "fail";
  if (hasPending) return "pending";
  return "ok";
}

// cwd の git ブランチに紐づく PR とその CI 状態を gh から取得する。
// 返り値: { pr: "PR #123", kind: "ok"|"fail"|"pending"|"merged"|"closed"|null }。
// PR が無い・gh 失敗 (認証切れ・非 GitHub リポジトリ等)・リポジトリ外は { pr: null, kind: null }。
function fetchPrStatus(cwd, branch = currentBranch(cwd)) {
  if (!branch) return { pr: null, kind: null };

  const r = spawnSync(
    "gh",
    ["pr", "view", branch, "--json", "number,state,statusCheckRollup"],
    { cwd, encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] },
  );
  if (r.status !== 0 || !r.stdout) return { pr: null, kind: null };

  let data;
  try {
    data = JSON.parse(r.stdout);
  } catch {
    return { pr: null, kind: null };
  }
  if (!data.number) return { pr: null, kind: null };

  const pr = `PR #${data.number}`;
  // マージ済み / クローズ済みは CI ではなく PR 状態を出す。
  const st = (data.state || "").toUpperCase();
  if (st === "MERGED") return { pr, kind: "merged" };
  if (st === "CLOSED") return { pr, kind: "closed" };

  return { pr, kind: rollupKind(data.statusCheckRollup) };
}

// workspace の tokens を更新する。値が null の token はクリアする。
function reportMetadata(workspaceId, tokens, ttlMs = DEFAULT_TTL_MS) {
  const args = ["workspace", "report-metadata", workspaceId, "--source", SOURCE, "--ttl-ms", String(ttlMs)];
  for (const [name, value] of Object.entries(tokens)) {
    if (value == null || value === "") {
      args.push("--clear-token", name);
    } else {
      args.push("--token", `${name}=${value}`);
    }
  }
  herdr(args);
}

// workspace_id に対応する cwd を取得する。まず context で渡された cwd を優先し、
// 無ければ pane list からその workspace の (フォーカスされた) pane の cwd を引く。
function workspaceCwd(workspaceId, fallbackCwd) {
  if (fallbackCwd) return fallbackCwd;

  const result = herdrJson(["pane", "list"]);
  const panes = result?.panes;
  if (!Array.isArray(panes)) return null;

  const inWorkspace = panes.filter((p) => p.workspace_id === workspaceId);
  if (inWorkspace.length === 0) return null;

  const focused = inWorkspace.find((p) => p.focused) || inWorkspace[0];
  return focused.cwd || focused.foreground_cwd || null;
}

// CI 種別 → (トークン名, 表示記号) のマッピング。
// sidebar トークンは固定色なので状態ごとに別トークンへ出し分け、config.toml 側で色を割り当てる。
// 常にこのうち 1 つだけに値が入る。
const CI_TOKENS = {
  ok: ["CI_OK", "✓"],
  fail: ["CI_FAIL", "✗"],
  pending: ["CI_PENDING", "●"],
  merged: ["CI_MERGED", "merged"],
  closed: ["CI_CLOSED", "closed"],
};
// 未該当のトークンをクリアするための全トークン名。
const ALL_CI_TOKENS = Object.values(CI_TOKENS).map(([name]) => name);

// workspace ごとのキャッシュファイルのパス。state ディレクトリが無ければ null (= キャッシュ無効)。
function cacheFile(workspaceId) {
  if (!stateDir) return null;
  const safe = workspaceId.replace(/[^A-Za-z0-9_-]/g, "_");
  return path.join(stateDir, `fetch-${safe}.json`);
}

// 直近 FETCH_CACHE_TTL_MS 以内に同じ workspace+branch を取得済みなら true。
function recentlyFetched(workspaceId, branch, nowMs) {
  const file = cacheFile(workspaceId);
  if (!file) return false;
  try {
    const cached = JSON.parse(fs.readFileSync(file, "utf8"));
    return cached.branch === branch && nowMs - cached.at < FETCH_CACHE_TTL_MS;
  } catch {
    return false;
  }
}

// 取得時刻と branch を記録する。書き込み失敗は無視する (best-effort)。
function recordFetch(workspaceId, branch, nowMs) {
  const file = cacheFile(workspaceId);
  if (!file) return;
  try {
    fs.writeFileSync(file, JSON.stringify({ branch, at: nowMs }));
  } catch {
    // 書けなくても本処理は続行する。
  }
}

// 1 つの workspace の PR/CI を取得して tokens に反映する。
// useCache=true (イベント起動) は直近取得済みの同一 workspace+branch をスキップする。
function refreshWorkspace(workspaceId, cwdHint, useCache = false) {
  const cwd = workspaceCwd(workspaceId, cwdHint);
  if (!cwd) return;

  const branch = currentBranch(cwd);
  const now = Date.now();
  if (useCache && recentlyFetched(workspaceId, branch, now)) return;

  const status = fetchPrStatus(cwd, branch);

  // 全 CI トークンをクリア対象として並べ、該当する状態のトークンだけ値を入れる。
  const tokens = { PR: status.pr };
  for (const name of ALL_CI_TOKENS) tokens[name] = null;

  const mapping = CI_TOKENS[status.kind];
  if (mapping) {
    const [name, symbol] = mapping;
    tokens[name] = symbol;
  }

  reportMetadata(workspaceId, tokens);
  recordFetch(workspaceId, branch, now);
}

// 起動スクリプト (refresh.js / refresh-all.js) が使うエントリポイントのみ公開する。
module.exports = {
  herdrJson,
  refreshWorkspace,
};
