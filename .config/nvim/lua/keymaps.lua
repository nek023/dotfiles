-- 高速移動
vim.keymap.set("", "H", "^")
vim.keymap.set("", "J", "}")
vim.keymap.set("", "K", "{")
vim.keymap.set("", "L", "$")

-- 行移動を見た目上の移動にする
vim.keymap.set("", "j", "gj")
vim.keymap.set("", "k", "gk")

-- 行頭・行末移動
vim.keymap.set("", "9", "^")
vim.keymap.set("", "0", "$")

-- 挿入モードでShift+Tabでインデントを減らす
vim.keymap.set("i", "<S-Tab>", "<C-d>")

-- ビジュアルモードでインデントを継続的に変更できるようにする
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- 検索にヒットした候補に移動したときに表示位置を中央に修正する
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "g*", "g*zz")
vim.keymap.set("n", "g#", "g#zz")

-- 検索にヒットした文字列のハイライトを非表示にする
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR>", { silent = true })

-- ウィンドウのリサイズ幅を変更する
vim.keymap.set("n", "<C-w>+", ":resize +5<CR>", { silent = true })
vim.keymap.set("n", "<C-w>-", ":resize -5<CR>", { silent = true })
vim.keymap.set("n", "<C-w>>", ":vertical resize +10<CR>", { silent = true })
vim.keymap.set("n", "<C-w><", ":vertical resize -10<CR>", { silent = true })

-- 新しいタブを開く
vim.keymap.set("n", "tt", ":tablast <bar> tabnew<CR>", { silent = true })

-- タブを閉じる
vim.keymap.set("n", "tc", ":tabclose<CR>", { silent = true })

-- 前後のタブに移動する
vim.keymap.set("n", "tn", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "tp", ":tabprevious<CR>", { silent = true })

-- nvim-telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fb", telescope.buffers)
vim.keymap.set("n", "<leader>fh", telescope.help_tags)

-- nvim-tree
vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>", { silent = true })
