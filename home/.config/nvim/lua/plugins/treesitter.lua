-- The `main` branch is the ongoing rewrite and has no tagged releases, so pin a
-- known-good commit rather than tracking a moving target. Unpinning means the new
-- API (require("nvim-treesitter").install) can change under us at any update.
local filetypes = {
    "bash", "go", "javascript", "json", "json5", "lua", "make", "markdown",
    "ruby", "terraform", "typescript"
}

return {{
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    commit = "4916d6592ede8c07973490d9322f187e07dfefac",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site"
        })
        require("nvim-treesitter").install(filetypes)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetypes,
            callback = function()
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        })
    end
}}
