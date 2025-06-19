return {
  "nvim-lualine/lualine.nvim", 
  config = function()
    vim.cmd([[
      highlight Comment        guifg=#ff9ac1 gui=italic
      highlight Keyword        guifg=#ff8b39 gui=bold
      highlight Function       guifg=#9aedfe gui=bold
      highlight String         guifg=#e0ff87
      highlight Type           guifg=#ffb86c
      highlight Normal         guibg=NONE
      highlight NormalNC       guibg=NONE
      highlight LineNr         guifg=#5c6370
      highlight CursorLineNr   guifg=#ff9ac1 gui=bold
      highlight Visual         guibg=#3c3c55
      highlight DiagnosticError guifg=#ff5555
      highlight DiagnosticWarn  guifg=#ffb86c
      highlight DiagnosticInfo  guifg=#8be9fd
      highlight DiagnosticHint  guifg=#50fa7b
      highlight TelescopeNormal guibg=NONE
      highlight TelescopeBorder guifg=#ff9ac1
      highlight TelescopePromptBorder guifg=#ff8b39
      highlight TelescopeResultsBorder guifg=#9aedfe
      highlight TelescopePreviewBorder guifg=#e0ff87
    ]])
  end,
}
