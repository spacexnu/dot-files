return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        priority = 1000,
        config = true,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "jay-babu/mason-nvim-dap.nvim",
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            local mason_dap = require("mason-nvim-dap")

            require("nvim-dap-virtual-text").setup()

            dapui.setup()

            mason_dap.setup({
                ensure_installed = { "python", "delve", "codelldb", "js-debug-adapter" },
                automatic_installation = true,
            })

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end

            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
}

