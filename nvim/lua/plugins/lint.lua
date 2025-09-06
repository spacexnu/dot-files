return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- Only run eslint if a config is present in project
      local eslint = lint.linters.eslint_d
      if eslint then
        eslint.condition = function(ctx)
          local config = vim.fs.find({
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.json",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            "package.json",
          }, { path = ctx.filename, upward = true })[1]
          return config ~= nil
        end
      end

      local group = vim.api.nvim_create_augroup("LintOnEvents", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = group,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Run linters for current file" })
    end,
  },
}

