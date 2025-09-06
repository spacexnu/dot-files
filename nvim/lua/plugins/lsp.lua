return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- Capabilities for nvim-cmp completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Common on_attach for keymaps and formatting
      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
        end
        map("n", "K", vim.lsp.buf.hover, "LSP Hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "LSP Rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")

        -- Inlay hints: enable if server supports it (handles Neovim 0.9/0.10)
        if client.server_capabilities and client.server_capabilities.inlayHintProvider then
          local ih = vim.lsp.inlay_hint
          pcall(function()
            if type(ih) == "table" and ih.enable then
              ih.enable(true, { bufnr = bufnr })
            else
              ih(bufnr, true)
            end
          end)
        end

        -- Format on save (defer to conform if present)
        if client.supports_method("textDocument/formatting") then
          local group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })
          vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
              -- If conform is available, let it handle formatting
              local ok_conform, conform = pcall(require, "conform")
              if ok_conform then
                conform.format({ bufnr = bufnr, lsp_fallback = true, quiet = true })
              else
                vim.lsp.buf.format({ async = false })
              end
            end,
          })
        end
      end

      -- Mason setup for LSP servers
      local ok_mason, mason = pcall(require, "mason")
      if ok_mason then mason.setup() end

      local ok_mlsp, mason_lspconfig = pcall(require, "mason-lspconfig")
      if ok_mlsp then
        mason_lspconfig.setup({
          ensure_installed = {
            -- Python
            "pyright",
            -- Go
            "gopls",
            -- Web / JS / TS / HTML
            "vtsls",
            "html",
            -- Markdown
            "marksman",
          },
          automatic_installation = true,
        })
      end

      -- Per-server settings
      local servers = {
        pyright = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              analyses = { unreachable = true, nilness = true, unusedparams = true, shadow = true },
              staticcheck = true,
            },
          },
        },
        vtsls = {
          settings = {
            vtsls = {
              enableMoveToFileCodeAction = true,
            },
            typescript = {
              format = { semicolons = "insert" },
              suggest = { completeFunctionCalls = true, autoImports = true },
              updateImportsOnFileMove = { enabled = "always" },
              preferences = {
                importModuleSpecifierPreference = "non-relative",
                includeCompletionsForImportStatements = true,
                quotePreference = "auto",
              },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              format = { semicolons = "insert" },
              suggest = { completeFunctionCalls = true, autoImports = true },
              updateImportsOnFileMove = { enabled = "always" },
              preferences = {
                importModuleSpecifierPreference = "non-relative",
                includeCompletionsForImportStatements = true,
                quotePreference = "auto",
              },
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        marksman = {},
      }

      -- Setup handlers via mason-lspconfig if available and supports setup_handlers, else fallback loop
      if ok_mlsp and type(mason_lspconfig.setup_handlers) == "function" then
        mason_lspconfig.setup_handlers({
          function(server)
            local opts = servers[server] or {}
            opts.capabilities = capabilities
            opts.on_attach = on_attach
            lspconfig[server].setup(opts)
          end,
        })
      else
        for server, opts in pairs(servers) do
          opts.capabilities = capabilities
          opts.on_attach = on_attach
          lspconfig[server].setup(opts)
        end
      end

      -- Diagnostics appearance
      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      })
    end,
  },
}
