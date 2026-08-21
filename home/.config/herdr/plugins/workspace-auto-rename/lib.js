"use strict";

// workspace の label を cwd に合わせて付け直す。ghq root 配下のリポジトリなら "org/repo"、
// それ以外は herdr の自動命名と同じディレクトリ名。worktree は元リポジトリを辿って判定するので、
// checkout が ghq root の外にあっても同じ label になる。

const { spawnSync } = require("node:child_process");
const fs = require("node:fs");
const os = require("node:os");
const path = require("node:path");

const herdrBin = process.env.HERDR_BIN_PATH || "herdr";

function herdr(args) {
  const r = spawnSync(herdrBin, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] });
  if (r.status !== 0 || !r.stdout) return null;
  return r.stdout;
}

function herdrJson(args) {
  const out = herdr(args);
  if (!out) return null;
  try {
    return JSON.parse(out).result ?? null;
  } catch {
    return null;
  }
}

function git(cwd, args) {
  const r = spawnSync("git", ["-C", cwd, ...args], {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "ignore"],
  });
  if (r.status !== 0) return null;
  const out = r.stdout.trim();
  return out || null;
}

function realpath(p) {
  try {
    return fs.realpathSync(p);
  } catch {
    return null;
  }
}

function ghqRoot() {
  const r = spawnSync("ghq", ["root"], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] });
  const fromGhq = r.status === 0 ? r.stdout.split("\n")[0].trim() : "";
  return realpath(fromGhq || path.join(os.homedir(), "ghq"));
}

// worktree なら共通 git dir (<main>/.git) の親、通常の checkout なら toplevel。
function mainRepoRoot(cwd) {
  const commonDir = git(cwd, ["rev-parse", "--path-format=absolute", "--git-common-dir"]);
  if (!commonDir) return null;
  // submodule では共通 git dir が <parent>/.git/modules/<name> になるので toplevel に倒す。
  if (path.basename(commonDir) === ".git") return path.dirname(commonDir);
  return git(cwd, ["rev-parse", "--show-toplevel"]);
}

// <ghq root>/<host>/<org>/<repo>/... なら "org/repo"、それ以外は null。
function ghqLabel(cwd, root) {
  if (!root) return null;

  const repoRoot = realpath(mainRepoRoot(cwd) || cwd);
  const rel = path.relative(root, repoRoot);
  if (!rel || rel.startsWith("..") || path.isAbsolute(rel)) return null;

  const [host, org, repo] = rel.split(path.sep);
  if (!host || !org || !repo) return null;
  return `${org}/${repo}`;
}

// herdr が cwd から自動で付ける label。ホームは "~"、それ以外はディレクトリ名。
function autoLabel(cwd) {
  return cwd === os.homedir() ? "~" : path.basename(cwd);
}

function labelFor(cwd, root = ghqRoot()) {
  const real = realpath(cwd);
  if (!real) return null;
  return ghqLabel(real, root) || autoLabel(real);
}

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

function currentLabel(workspaceId) {
  const result = herdrJson(["workspace", "get", workspaceId]);
  return result?.workspace?.label ?? null;
}

function renameWorkspace(workspaceId, cwdHint, root = ghqRoot()) {
  const cwd = workspaceCwd(workspaceId, cwdHint);
  if (!cwd) return null;

  const label = labelFor(cwd, root);
  if (!label || label === currentLabel(workspaceId)) return null;

  herdr(["workspace", "rename", workspaceId, label]);
  return label;
}

module.exports = {
  ghqRoot,
  herdrJson,
  labelFor,
  renameWorkspace,
};
