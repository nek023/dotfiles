local function builtin(name)
  return function()
    require("telescope.builtin")[name]()
  end
end

return {{
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.2",
  dependencies = {"nvim-lua/plenary.nvim"},
  cmd = "Telescope",
  keys = {
    { "<leader>ff", builtin("find_files"), desc = "Telescope find files" },
    { "<leader>fg", builtin("live_grep"), desc = "Telescope live grep" },
    { "<leader>fb", builtin("buffers"), desc = "Telescope buffers" },
    { "<leader>fh", builtin("help_tags"), desc = "Telescope help tags" },
  }
}}
