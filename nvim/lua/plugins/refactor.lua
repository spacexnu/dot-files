return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("refactoring").setup({})

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true, desc = "" }

    -- Visual mode: Extract Function
    map("v", "<leader>re", function()
      require("refactoring").refactor("Extract Function")
    end, vim.tbl_extend("force", opts, { desc = "Extract Function" }))

    -- Visual mode: Extract Variable
    map("v", "<leader>rv", function()
      require("refactoring").refactor("Extract Variable")
    end, vim.tbl_extend("force", opts, { desc = "Extract Variable" }))

    -- Visual mode: Inline Variable
    map("v", "<leader>ri", function()
      require("refactoring").refactor("Inline Variable")
    end, vim.tbl_extend("force", opts, { desc = "Inline Variable" }))

    -- Normal mode: Rename via LSP
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP Rename" }))

    -- Normal mode: Print var (debug)
    map("n", "<leader>rp", function()
      require("refactoring").debug.printf({ below = false })
    end, vim.tbl_extend("force", opts, { desc = "Debug Print (below)" }))

    -- Visual mode: Print selected var
    map("v", "<leader>rp", function()
      require("refactoring").debug.print_var()
    end, vim.tbl_extend("force", opts, { desc = "Debug Print Var" }))

    -- Clean debug prints
    map("n", "<leader>rc", function()
      require("refactoring").debug.cleanup({})
    end, vim.tbl_extend("force", opts, { desc = "Cleanup Debug Prints" }))
  end,
}
