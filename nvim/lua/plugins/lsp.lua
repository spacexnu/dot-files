return {
  -- Keep nvim-lspconfig installed: it provides server config data (lsp/*).
  { "neovim/nvim-lspconfig" },

  -- Install LSP servers
  { "williamboman/mason.nvim", config = true },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "pyright",
        "tsserver", -- Mason package name (keep this)
        "gopls",
        "clangd",
        "bashls",
        "marksman",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Capabilities for nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Keymaps on attach (new recommended style)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local buf = ev.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "K",  vim.lsp.buf.hover, "Hover")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        end,
      })

      -- Configure servers using the new API (NO require('lspconfig') framework)
      vim.lsp.config("pyright",   { capabilities = capabilities })
      vim.lsp.config("gopls",     { capabilities = capabilities })
      vim.lsp.config("clangd",    { capabilities = capabilities })
      vim.lsp.config("bashls",    { capabilities = capabilities })
      vim.lsp.config("marksman",  { capabilities = capabilities })

      -- TypeScript/JavaScript:
      -- lspconfig renamed "tsserver" -> "ts_ls" (config name).
      -- Mason still installs it as tsserver. Enable ts_ls here.
      vim.lsp.config("ts_ls",     { capabilities = capabilities })

      -- Enable them (activates per filetype)
      vim.lsp.enable({
        "pyright",
        "ts_ls",
        "gopls",
        "clangd",
        "bashls",
        "marksman",
      })
    end,
  },
}
