vim.o.background = "dark"
vim.cmd.colorscheme("vscode")

require("vscode").setup({
    transparent = false,
    italic_comments = true,
    disable_nvimtree_bg = true,
})
