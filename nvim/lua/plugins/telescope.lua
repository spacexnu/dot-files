return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          path_display = { "truncate" },
          file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/" },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
