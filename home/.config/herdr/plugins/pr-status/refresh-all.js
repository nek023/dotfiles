"use strict";

// 全 workspace の PR/CI ステータスを更新する。startup フック (サーバ起動 / live handoff 後) から起動。
// 定期更新したい場合は各環境の cron / launchd / systemd timer から叩く。

const { herdrJson, refreshWorkspace } = require("./lib");

const result = herdrJson(["workspace", "list"]);
const workspaces = result?.workspaces;
if (Array.isArray(workspaces)) {
  for (const ws of workspaces) {
    refreshWorkspace(ws.workspace_id);
  }
}
