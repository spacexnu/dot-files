return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.register({
        f = { name = "Find" },
      }, { prefix = "<leader>" })
    end,
  },
}
