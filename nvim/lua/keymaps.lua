local map = vim.keymap.set
local function toggle_nvim_tree()
  local loaded, api = pcall(require, "nvim-tree.api")
  if loaded then
    api.tree.toggle()
  else
    vim.cmd("NvimTreeToggle")
  end
end

map("n", "<leader>e", toggle_nvim_tree, { desc = "Toggle file explorer" })
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
