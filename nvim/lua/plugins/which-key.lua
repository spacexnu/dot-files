return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>d", group = "Debug" },
        { "<leader>g", group = "Git" },
        { "<leader>c", group = "Code" },
        { "<leader>x", group = "Trouble" },
        { "<leader>a", group = "Claude" },
        { "<leader>b", group = "Buffer" },
      })
    end,
  },
}
