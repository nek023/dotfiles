"use strict";

// 単一 workspace の label を付け直す。event フックと手動 action の双方から起動される。

const { renameWorkspace } = require("./lib");

function parseJsonEnv(name) {
  const raw = process.env[name];
  if (!raw) return {};
  try {
    return JSON.parse(raw) ?? {};
  } catch {
    return {};
  }
}

function resolveContext() {
  const ctx = parseJsonEnv("HERDR_PLUGIN_CONTEXT_JSON");
  const event = parseJsonEnv("HERDR_PLUGIN_EVENT_JSON");

  const workspaceId =
    process.env.HERDR_WORKSPACE_ID || ctx.workspace_id || event.workspace?.workspace_id || null;
  const cwdHint =
    ctx.workspace_cwd || ctx.focused_pane_cwd || ctx.worktree?.path || event.worktree?.path || null;
  return { workspaceId, cwdHint };
}

const { workspaceId, cwdHint } = resolveContext();
if (workspaceId) {
  renameWorkspace(workspaceId, cwdHint);
}
