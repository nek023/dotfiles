local parsers = {
  "bash", "go", "javascript", "json", "json5", "lua", "make", "markdown",
  "ruby", "terraform", "typescript"
}

local filetypes = {
  "sh", "bash", "go", "javascript", "json", "json5", "lua", "make", "markdown",
  "ruby", "tf", "terraform", "typescript"
}

return {{
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site"
    })
    require("nvim-treesitter").install(parsers)
    vim.treesitter.language.register("terraform", "tf")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    })
  end
}}
