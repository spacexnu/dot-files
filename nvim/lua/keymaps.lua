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

-- LSP Navigation (via Telescope)
map_telescope("gd", "lsp_definitions", "Go to definition")
map_telescope("gr", "lsp_references", "Find references")
map_telescope("gi", "lsp_implementations", "Go to implementation")
map_telescope("<leader>td", "lsp_type_definitions", "Go to type definition")
map_telescope("<leader>ds", "lsp_document_symbols", "Document symbols")
map_telescope("<leader>ws", "lsp_workspace_symbols", "Workspace symbols")
map_telescope("<leader>ca", "lsp_code_actions", "Code actions")
map_telescope("<leader>rn", "lsp_rename", "Rename symbol")

map_telescope("<leader>ld", "diagnostics", "Show diagnostics")
map_telescope("<leader>lq", "quickfix", "Quickfix list")

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

-- Theme toggle: light (Latte) <-> dark (Frappe)
map("n", "<leader>ut", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
    vim.cmd("colorscheme catppuccin-latte")
  else
    vim.o.background = "dark"
    vim.cmd("colorscheme catppuccin-frappe")
  end
  -- ColorScheme autocmd will re-apply UI tweaks
end, { desc = "Toggle theme (light/dark)", noremap = true, silent = true })
