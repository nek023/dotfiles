require("config.lazy")
for _, module in ipairs({ "options", "keymaps", "lsp" }) do
  package.loaded[module] = nil
  require(module)
end

pcall(vim.cmd, [[colorscheme iceberg]])
