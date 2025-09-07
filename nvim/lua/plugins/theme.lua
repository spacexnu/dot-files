return {
	-- Catppuccin Latte as default (light) and Frappe for dark
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			-- Default to dark (Frappe)
			vim.o.background = "dark"
			require("catppuccin").setup({
				flavour = "frappe",
				background = { light = "latte", dark = "frappe" },
				-- Keep solid background for dark (better contrast); light tweaks handle transparency
				transparent_background = false,
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
			-- Respect current background (light/dark) mapping
			vim.cmd("colorscheme catppuccin")
		end,
	},
}
