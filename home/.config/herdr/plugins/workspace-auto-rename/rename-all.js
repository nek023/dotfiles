"use strict";

// 全 workspace の label を付け直す。startup フック (サーバ起動 / live handoff 後) から起動。

const { ghqRoot, herdrJson, renameWorkspace } = require("./lib");

const root = ghqRoot();
const result = herdrJson(["workspace", "list"]);
const workspaces = result?.workspaces;
if (Array.isArray(workspaces)) {
  for (const ws of workspaces) {
    renameWorkspace(ws.workspace_id, null, root);
  }
}
