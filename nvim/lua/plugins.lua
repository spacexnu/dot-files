local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local function ensure_lazy()
  if not vim.loop.fs_stat(lazypath) then
    local clone_cmd = {
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      lazypath
    }
    print("Cloning lazy.nvim...")
    local result = vim.fn.system(clone_cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("Failed to clone lazy.nvim: " .. result, vim.log.levels.ERROR)
      return false
    end
  end
  vim.opt.rtp:prepend(lazypath)
  return true
end

if not ensure_lazy() then
  error("Could not install lazy.nvim automatically. Please clone manually.")
  return
end

require("lazy").setup({
  { "neovim/nvim-lspconfig", lazy = false },
  { "Mofiqul/vscode.nvim", priority = 1000, lazy = false },
  { "hrsh7th/nvim-cmp", lazy = false },
  { "hrsh7th/cmp-nvim-lsp", lazy = false },
  { "L3MON4D3/LuaSnip", lazy = false },
  { "saadparwaiz1/cmp_luasnip", lazy = false },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = false },
  { "lewis6991/gitsigns.nvim", event = "BufReadPre" },
  { "nvim-lualine/lualine.nvim", lazy = false },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
      require("nvim-tree").setup()
    end,
  },
  { "nvim-telescope/telescope.nvim", cmd = "Telescope" },
  { "nvim-lua/plenary.nvim" },
  { "folke/which-key.nvim", lazy = false, config = true },
})

vim.cmd([[colorscheme vscode]])
