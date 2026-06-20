return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",

      -- Adapters / debug binaries
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP Conditional Breakpoint" },
      { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP Log Point" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "DAP Open REPL" },
      { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "DAP Run to Cursor" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "DAP Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI Toggle" },
      { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, mode = { "n", "v" }, desc = "DAP Eval expression" },
      -- Go: debug nearest test
      { "<leader>dt", function() require("dap-go").debug_test() end, ft = "go", desc = "DAP Go: debug test" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Install debug adapters via Mason (debugpy for Python, delve for Go).
      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "delve" },
        automatic_installation = true,
        handlers = {}, -- use default handlers
      })

      dapui.setup()
      require("nvim-dap-virtual-text").setup()

      -- Python: point dap-python at Mason's debugpy install.
      local mason_dir = vim.fn.stdpath("data") .. "/mason"
      local debugpy_python = mason_dir .. "/packages/debugpy/venv/bin/python"
      if vim.fn.executable(debugpy_python) == 1 then
        require("dap-python").setup(debugpy_python)
      else
        require("dap-python").setup("python3")
      end
      -- Prefer the project virtualenv at runtime when one is active.
      require("dap-python").resolve_python = function()
        local venv = os.getenv("VIRTUAL_ENV")
        if venv then
          return venv .. "/bin/python"
        end
        return nil
      end

      -- Go: delve-based configs (debug, test, attach).
      require("dap-go").setup()

      -- Auto-open/close the UI around sessions.
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Breakpoint signs.
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual", numhl = "" })
    end,
  },
}
