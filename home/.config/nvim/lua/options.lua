-- https://neovim.io/doc/user/options.html
-- https://neovim.io/doc/user/vim_diff.html

-- 行番号を表示
vim.opt.number = true

-- 自動インデントでコードの構造に応じたインデントを挿入する
vim.opt.smartindent = true

-- タブ文字の代わりにスペースを挿入する
vim.opt.expandtab = true

-- タブ文字を何文字のスペースとして表示するか
vim.opt.tabstop = 4

-- タブ文字をキーボードで入力した際に何文字の空白文字にするか
vim.opt.softtabstop = 4

-- インデントを変更する際に何文字分ずらすか
vim.opt.shiftwidth = 4

-- インデント幅がshiftwidthの値の倍数になるようにスペースを挿入する
vim.opt.shiftround = true

-- 複数のコマンドがマッチする場合、リストを表示して最初の候補を挿入する
vim.opt.wildmode = "list:full"

-- 検索時に大文字小文字を無視する
vim.opt.ignorecase = true

-- 大文字を含めて検索した場合は大文字小文字を無視しない
vim.opt.smartcase = true

-- バッファのスワップファイルを作成しない
vim.opt.swapfile = false

-- システムのクリップボードと連携する
-- コピーは OSC 52 でターミナル (Ghostty) に委ね、ローカル/リモート (mosh) を
-- 問わず同じ仕組みで pasteboard へ転送する。tmux 側で set-clipboard on が前提。
-- ペーストは OSC 52 read が Ghostty のセキュリティ制約で動かないため、
-- pbpaste が使える環境ではそれを優先し、無ければ OSC 52 にフォールバックする。
vim.opt.clipboard:append({"unnamedplus"})
local osc52 = require("vim.ui.clipboard.osc52")
local has_pbpaste = vim.fn.executable("pbpaste") == 1
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  paste = has_pbpaste and {
    ["+"] = { "pbpaste" },
    ["*"] = { "pbpaste" },
  } or {
    ["+"] = osc52.paste("+"),
    ["*"] = osc52.paste("*"),
  },
}

--  24bit colorを有効化
vim.opt.termguicolors = true
