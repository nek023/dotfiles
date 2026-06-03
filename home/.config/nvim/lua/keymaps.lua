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
vim.keymap.set("n", "<Esc><Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- ウィンドウのリサイズ幅を変更する
vim.keymap.set("n", "<C-w>+", "<cmd>resize +5<CR>", { silent = true })
vim.keymap.set("n", "<C-w>-", "<cmd>resize -5<CR>", { silent = true })
vim.keymap.set("n", "<C-w>>", "<cmd>vertical resize +10<CR>", { silent = true })
vim.keymap.set("n", "<C-w><", "<cmd>vertical resize -10<CR>", { silent = true })

-- 新しいタブを開く
vim.keymap.set("n", "tt", "<cmd>tablast <bar> tabnew<CR>", { silent = true })

-- タブを閉じる
vim.keymap.set("n", "tc", "<cmd>tabclose<CR>", { silent = true })

-- 前後のタブに移動する
vim.keymap.set("n", "tn", "<cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n", "tp", "<cmd>tabprevious<CR>", { silent = true })

-- nvim-telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fb", telescope.buffers)
vim.keymap.set("n", "<leader>fh", telescope.help_tags)

-- nvim-tree
vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<CR>", { silent = true })

-- VSCode 統合ターミナル (xterm.js) での Shift+数字 記号入力の修正。
-- Neovim 0.12+ が kitty keyboard protocol (CSI > 3 u) を有効化すると、
-- xterm.js のバグで Shift+9 等が記号 (例: `(`) に変換されず生キー `9` + Shift
-- として届き、数字が入力されてしまう。VSCode のときだけ <S-数字> を記号へ
-- 再マップして回避する。xterm.js#5791 が VSCode に取り込まれれば不要になる。
if vim.env.TERM_PROGRAM == "vscode" then
  -- US 配列の Shift+数字 → 記号の対応表
  local shift_symbol = {
    ["0"] = ")",
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
  }

  -- getcharstr が返す内部キーコード (0x80 0xfc 0x02 <ascii>: Shift 修飾付き生キー)
  -- を記号へ変換する。r や f/t など getcharstr 経由のモーション用。
  local function translate_shift_key(char)
    if not char or char == "" then
      return nil
    end
    if #char == 4 and char:byte(1) == 0x80 and char:byte(2) == 0xfc and char:byte(3) == 0x02 then
      local key = string.char(char:byte(4))
      return shift_symbol[key] or char
    end
    return char
  end

  local function getchar_translated()
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok or not char or char == "" or char == "\x1b" then
      return nil
    end
    return translate_shift_key(char)
  end

  -- 通常の入力 (挿入・ノーマル・コマンドライン等) 向けに <S-数字> を記号へ
  for num, sym in pairs(shift_symbol) do
    vim.keymap.set({ "n", "x", "s", "o", "i", "c", "t", "l" }, "<S-" .. num .. ">", sym, { noremap = true })
  end

  -- r (置換) は getcharstr 経由のため別途変換する
  vim.keymap.set("n", "r", function()
    local char = getchar_translated()
    if char then
      vim.cmd("normal! r" .. char)
    end
  end, { noremap = true })

  -- f/F/t/T (文字検索移動) も getcharstr 経由のため別途変換する
  for _, cmd in ipairs({ "f", "F", "t", "T" }) do
    vim.keymap.set({ "n", "x", "o" }, cmd, function()
      local char = getchar_translated()
      if char then
        vim.cmd("normal! " .. cmd .. char)
      end
    end, { noremap = true })
  end
end
