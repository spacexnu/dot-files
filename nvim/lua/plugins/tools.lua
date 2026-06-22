return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "ruff",
        "goimports",
        "gofumpt",
        "prettier",
        "shfmt",
      },
      run_on_start = true,
    },
  },
}
