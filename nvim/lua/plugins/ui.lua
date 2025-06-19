return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({})
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "nightfly",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                defaults = {
                    winblend = 10,
                    layout_config = {
                        horizontal = { width = 0.9 },
                        vertical = { width = 0.9 },
                    },
                    sorting_strategy = "ascending",
                    borderchars = {
                        prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                        results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                        preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                    },
                },
            })
        end,
    }
}
