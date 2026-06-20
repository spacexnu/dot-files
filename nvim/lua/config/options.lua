vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Persistent undo across sessions
vim.opt.undofile = true

-- Keep context around the cursor and avoid jumpy horizontal scroll
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Faster, quieter editing
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.wrap = false

-- Go uses tabs; don't expand there
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})
