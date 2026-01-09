return {
 -- Copilot core (autocomplete)
 {
   "zbirenbaum/copilot.lua",
   cmd = "Copilot",
   event = "InsertEnter",
   config = function()
     require("copilot").setup({
       suggestion = {
         enabled = true,
         auto_trigger = true,
         keymap = {
           accept = "<C-l>",     -- accept suggestion (same as set in Codeium)
           next = "<C-]>",       -- next suggestion
           prev = "<C-p>",       -- previous (avoid <Esc> / <C-[> conflict)
           dismiss = "<C-x>",    -- dismiss
         },
       },
       panel = { enabled = false },
     })
   end,
 },
--
 -- Copilot Chat (chat inside Neovim)
 {
   "CopilotC-Nvim/CopilotChat.nvim",
   dependencies = {
     "zbirenbaum/copilot.lua",
     "nvim-lua/plenary.nvim",
   },
   cmd = {
     "CopilotChat",
     "CopilotChatOpen",
     "CopilotChatClose",
     "CopilotChatToggle",
   },
   config = function()
     require("CopilotChat").setup({
     })
   end,
 },
 }
