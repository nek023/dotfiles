-- nvim-treesitter was archived in 2026-04. Pin to the final commit on `main`
-- so the plugin's new API (require("nvim-treesitter").install) keeps working
-- on Neovim 0.12+ without depending on the upstream repo staying live.
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
