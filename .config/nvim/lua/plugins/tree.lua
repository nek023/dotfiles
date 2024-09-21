-- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#custom-mappings
local function tree_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
        }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "<C-e>", api.tree.close, opts("Close Tree"))
end

return {{
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("nvim-tree").setup({
            on_attach = tree_on_attach
        })
    end
}}
