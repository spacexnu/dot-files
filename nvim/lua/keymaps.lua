local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- File explorer toggle
vim.keymap.set("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle file explorer", noremap = true, silent = true })

-- Telescope
local function map_telescope(lhs, builtin_func, desc)
  vim.keymap.set("n", lhs, function()
    require("telescope.builtin")[builtin_func]()
  end, { desc = desc, noremap = true, silent = true })
end

map_telescope("<leader>ff", "find_files", "Find files")
map_telescope("<leader>fg", "live_grep", "Live grep")
map_telescope("<leader>fb", "buffers", "Find buffers")
map_telescope("<leader>fh", "help_tags", "Find help")

-- Buffers
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer", unpack(opts) })

-- Save/quit
map("n", "<leader>w", ":w<CR>", { desc = "Save file", unpack(opts) })
map("n", "<leader>q", ":q<CR>", { desc = "Quit", unpack(opts) })

-- Better navigation
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Clear search highlights
map("n", "<Esc>", ":nohlsearch<CR>", opts)
