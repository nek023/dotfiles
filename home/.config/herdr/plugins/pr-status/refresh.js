"use strict";

// 単一 workspace の PR/CI ステータスを更新する。action (手動) と event フックの双方から起動される。
// イベント起動 (HERDR_PLUGIN_EVENT あり) はキャッシュを有効にし、連打時の gh 呼び出しを抑制する。

const { refreshWorkspace } = require("./lib");

function resolveContext() {
  let ctx = {};
  if (process.env.HERDR_PLUGIN_CONTEXT_JSON) {
    try {
      ctx = JSON.parse(process.env.HERDR_PLUGIN_CONTEXT_JSON);
    } catch {
      ctx = {};
    }
  }

  const workspaceId = process.env.HERDR_WORKSPACE_ID || ctx.workspace_id || null;
  // cwd は context にあれば使い、無ければ refreshWorkspace 側で pane list から解決する。
  const cwdHint = ctx.workspace_cwd || ctx.focused_pane_cwd || null;
  return { workspaceId, cwdHint };
}

const { workspaceId, cwdHint } = resolveContext();
if (workspaceId) {
  const useCache = Boolean(process.env.HERDR_PLUGIN_EVENT);
  refreshWorkspace(workspaceId, cwdHint, useCache);
}
