
require("nvim-treesitter.configs").setup {
  ensure_installed = { "python", "bash", "go", "java", "html", "javascript", "markdown", "lua" },
  highlight = { enable = true },
}
