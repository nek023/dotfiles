return {{
    "brenoprata10/nvim-highlight-colors",
    config = function()
        local highlight = require("nvim-highlight-colors")
        highlight.setup({
            render = "background",
            enable_named_colors = false,
            enable_tailwind = true,
        })
        highlight.turnOn()
    end
}}
