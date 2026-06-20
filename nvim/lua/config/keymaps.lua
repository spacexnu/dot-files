local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
-- <leader>cf (format) lives in lua/plugins/conform.lua.

-- Harpoon keymaps live in lua/plugins/harpoon.lua (lazy `keys`).

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Buffers modal" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

map("n", "<leader>?", function()
  require("which-key").show()
end, { desc = "Show keymaps" })
