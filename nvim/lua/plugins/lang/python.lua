return {
    {
        "williamboman/mason.nvim",
        config = true
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "python" },
                automatic_installation = true,
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            local dap_python = require("dap-python")

            local venv = os.getenv("VIRTUAL_ENV") or "~/.virtualenvs/debugpy"
            dap_python.setup(venv .. "/bin/python")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            vim.fn.sign_define("DapBreakpoint", {
                text = "",
                texthl = "DiagnosticSignError",
                linehl = "",
                numhl = ""
            })

            vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "Start/Continue Debug" })
            vim.keymap.set("n", "<F9>", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<F10>", require("dap").step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<F11>", require("dap").step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<F12>", require("dap").step_out, { desc = "Step Out" })
            vim.keymap.set("n", "<leader>du", require("dapui").toggle, { desc = "Toggle Debugger UI" })
        end,
    },
}
