return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local conform = require("conform")

      conform.setup({
        -- Prefer explicit formatters; fall back to LSP
        formatters_by_ft = {
          python = { "ruff_format", "black" },
          go = { "gofumpt", "goimports" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
        },
        format_on_save = function(bufnr)
          local disabled = vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat
          if disabled then return nil end
          return { lsp_fallback = true, timeout_ms = 2000 }
        end,
      })

      -- Ensure external tools are installed via mason
      local ok_mti, mti = pcall(require, "mason-tool-installer")
      if ok_mti then
        mti.setup({
          ensure_installed = {
            -- LSP servers (duplicated ok; mason skips installed)
            "pyright", "gopls", "vtsls", "html", "marksman",
            -- Formatters
            "black", "ruff", "gofumpt", "goimports", "prettier", "stylua",
            -- Linters / DAP
            "eslint_d", "js-debug-adapter", "delve",
          },
          auto_update = false,
          run_on_start = true,
        })
      end

      -- Commands to toggle autoformat quickly
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "Disable format on save", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Enable format on save" })

      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format current buffer" })
    end,
  },
}
