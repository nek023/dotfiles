return {{
    "brenoprata10/nvim-highlight-colors",
    config = function()
        local highlight = require("nvim-highlight-colors")
        highlight.setup({
            render = "virtual",
            virtual_symbol = "■",
            virtual_symbol_prefix = "",
            virtual_symbol_suffix = " ",
            virtual_symbol_position = "inline"
        })
        highlight.turnOn()
    end
}}
