return {
  { "mfussenegger/nvim-dap" },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Auto-open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<F5>",  dap.continue,         { desc = "DAP Continue" })
      map("n", "<F10>", dap.step_over,        { desc = "DAP Step Over" })
      map("n", "<F11>", dap.step_into,        { desc = "DAP Step Into" })
      map("n", "<F12>", dap.step_out,         { desc = "DAP Step Out" })
      map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "DAP Conditional Breakpoint" })
      map("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end, { desc = "DAP Log Point" })

      map("n", "<leader>dr", dap.repl.open,   { desc = "DAP Open REPL" })
      map("n", "<leader>dc", dap.run_to_cursor, { desc = "DAP Run to Cursor" })
      map("n", "<leader>dx", dap.terminate,   { desc = "DAP Terminate" })
      map("n", "<leader>du", dapui.toggle,    { desc = "DAP UI Toggle" })
    end,
  },
}
