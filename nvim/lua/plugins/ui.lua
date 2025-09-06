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
                    -- Match current colorscheme automatically (works with monokai-pro-light)
                    theme = "auto",
                    -- Minimal separators suit light themes better
                    component_separators = { left = "", right = "" },
                    section_separators   = { left = "", right = "" },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { { "mode", icon = "" } },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
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
