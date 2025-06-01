local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function ensure_lazy()
  if not vim.loop.fs_stat(lazypath) then
    local clone_cmd = {
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      lazypath
    }
    print("Clonando lazy.nvim...")
    local result = vim.fn.system(clone_cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("Falha ao clonar lazy.nvim: " .. result, vim.log.levels.ERROR)
      return false
    end
  end
  vim.opt.rtp:prepend(lazypath)
  return true
end

if not ensure_lazy() then
  error("Não foi possível instalar o lazy.nvim automaticamente. Por favor, clone manualmente.")
  return
end

require("lazy").setup({
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "folke/tokyonight.nvim" },
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "lewis6991/gitsigns.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-tree/nvim-tree.lua",
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
})
