return {
	-- Catppuccin Latte as default (light, open-source)
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			vim.o.background = "light"
		require("catppuccin").setup({
			flavour = "latte",
			background = { light = "latte", dark = "mocha" },
			transparent_background = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				treesitter = true,
				telescope = true,
				which_key = true,
				nvimtree = true,
				mason = true,
				lsp_trouble = true,
				notify = true,
				neotree = false,
				mini = false,
			},
		})
			vim.cmd("colorscheme catppuccin-latte")
		end,
	},
}
