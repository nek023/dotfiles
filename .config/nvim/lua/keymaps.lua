vim.keymap.set("", "H", "^")
vim.keymap.set("", "J", "}")
vim.keymap.set("", "K", "{")
vim.keymap.set("", "L", "$")

vim.keymap.set("", "j", "gj")
vim.keymap.set("", "k", "gk")

vim.keymap.set("", "9", "^")
vim.keymap.set("", "0", "$")

-- nvim-telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fb", telescope.buffers)
vim.keymap.set("n", "<leader>fh", telescope.help_tags)

-- nvim-tree
vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>")
