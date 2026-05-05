local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim. Make sure git and network access are available.\n" .. output)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
})
