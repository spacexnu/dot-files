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
                ensure_installed = { "python", "delve", "js" },
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
            "leoluz/nvim-dap-go",
            "mxsdev/nvim-dap-vscode-js",
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

            -- Go DAP (delve)
            local ok_dapgo, dap_go = pcall(require, "dap-go")
            if ok_dapgo then
              dap_go.setup()
            end

            -- JavaScript / TypeScript DAP (js-debug via mason)
            local ok_registry, mason_registry = pcall(require, "mason-registry")
            local ok_js, dap_vscode_js = pcall(require, "dap-vscode-js")
            if ok_registry and ok_js then
              local ok_pkg, js_debug_pkg = pcall(mason_registry.get_package, "js-debug-adapter")
              if ok_pkg then
                local debugger_path = js_debug_pkg:get_install_path()
                dap_vscode_js.setup({
                  debugger_path = debugger_path,
                  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
                })

                for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                  dap.configurations[language] = {
                    {
                      type = "pwa-node",
                      request = "launch",
                      name = "Launch file",
                      program = "${file}",
                      cwd = "${workspaceFolder}",
                    },
                    {
                      type = "pwa-node",
                      request = "attach",
                      name = "Attach (9229)",
                      processId = require("dap.utils").pick_process,
                      cwd = "${workspaceFolder}",
                    },
                  }
                end
              end
            end
        end,
    },
}
