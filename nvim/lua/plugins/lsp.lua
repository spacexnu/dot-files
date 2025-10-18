return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", config = true },
			{
				"mason-org/mason-lspconfig.nvim",
				-- by default it already enables the installed servers (can disable with automatic_enable=false)
				opts = {
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
					automatic_enable = true,
				},
			},
			"hrsh7th/cmp-nvim-lsp",
		},

		config = function()
			---------------------------------------------------------------------------
			-- Capabilities (nvim-cmp)
			---------------------------------------------------------------------------
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp_lsp.default_capabilities(capabilities)
			end

			---------------------------------------------------------------------------
			-- on_attach: keymaps, inlay hints, format-on-save (with conform when available)
			---------------------------------------------------------------------------
			local on_attach = function(client, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
				end
				map("n", "K", vim.lsp.buf.hover, "LSP Hover")
				map("n", "<leader>rn", vim.lsp.buf.rename, "LSP Rename")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")

				-- Inlay hints (compat 0.9/0.10/0.11)
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

				-- Format on save (delegates to conform if present)
				if client.supports_method and client.supports_method("textDocument/formatting") then
					local group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })
					vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = group,
						buffer = bufnr,
						callback = function()
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

			---------------------------------------------------------------------------
			-- Per-server definitions (now via vim.lsp.config)
			-- Note: mason-lspconfig installs the binaries and, by default, calls vim.lsp.enable()
			---------------------------------------------------------------------------
			local function with_common(opts)
				opts = opts or {}
				opts.capabilities = capabilities
				opts.on_attach = on_attach
				return opts
			end

			-- Python
			vim.lsp.config(
				"pyright",
				with_common({
					-- settings = { python = { analysis = { typeCheckingMode = "basic" } } },
				})
			)

			-- Go
			vim.lsp.config(
				"gopls",
				with_common({
					settings = {
						gopls = {
							gofumpt = true,
							analyses = { unreachable = true, nilness = true, unusedparams = true, shadow = true },
							staticcheck = true,
						},
					},
				})
			)

			-- TypeScript/JavaScript via vtsls
			vim.lsp.config(
				"vtsls",
				with_common({
					settings = {
						vtsls = { enableMoveToFileCodeAction = true },
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
				})
			)

			-- HTML
			vim.lsp.config("html", with_common({}))

			-- Markdown
			vim.lsp.config("marksman", with_common({}))

			---------------------------------------------------------------------------
			-- If you want to manually force enabling (not needed when automatic_enable=true)
			-- vim.lsp.enable({ "pyright", "gopls", "vtsls", "html", "marksman" })
			---------------------------------------------------------------------------

			---------------------------------------------------------------------------
			-- Diagnostics (in 0.11 virtual_text is opt-in; this already enables it)
			---------------------------------------------------------------------------
			vim.diagnostic.config({
				virtual_text = { spacing = 2, prefix = "●" },
				severity_sort = true,
				float = { border = "rounded" },
			})

			-- Default border for all floats (hover/signature etc.) on 0.11+
			vim.o.winborder = "rounded"
		end,
	},
}
