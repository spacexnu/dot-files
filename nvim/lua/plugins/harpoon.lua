return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
      { "<leader>hh", function() local h = require("harpoon") h.ui:toggle_quick_menu(h:list()) end, desc = "Harpoon quick menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon to file 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon to file 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon to file 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon to file 4" },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },
}
