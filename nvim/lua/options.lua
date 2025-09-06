vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"

-- Filetype-specific indentation
local ftgroup = vim.api.nvim_create_augroup("FiletypeIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ftgroup,
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "html", "css", "json", "markdown" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = ftgroup,
  pattern = { "go" },
  callback = function()
    -- Go prefers tabs; gofmt/goimports will fix
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false
  end,
})
