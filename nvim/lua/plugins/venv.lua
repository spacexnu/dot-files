return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  opts = {
    search_venv_managers = true,
    parents = 3,
    name = {
      "venv",
      ".venv",
      "env",
      ".env",
      ".direnv/python-3.11",
    },
  },
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Use Cached VirtualEnv" },
  },
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  event = "VeryLazy",
}
