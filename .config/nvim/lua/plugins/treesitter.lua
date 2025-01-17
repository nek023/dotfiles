return {{
    "nvim-treesitter/nvim-treesitter",
    version = "^0.9.3",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = {"bash", "go", "javascript", "json", "json5", "lua", "make", "markdown", "ruby",
                                "terraform", "typescript"},
            sync_install = false,
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end
}}
