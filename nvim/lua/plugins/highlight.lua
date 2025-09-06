return {
  "nvim-lualine/lualine.nvim",
  config = function()
    -- Light theme: apply subtle, light-friendly tweaks only.
    if vim.o.background == "light" then
      vim.o.cursorline = true
      vim.cmd([[
        " General transparency and subtle tones for light mode
        highlight Normal           guibg=NONE
        highlight NormalNC         guibg=NONE
        highlight! link NormalFloat Normal

        " Cursor/lines
        highlight CursorLine       guibg=#f3f3f3
        highlight CursorLineNr     guifg=#6b6b6b gui=bold
        highlight LineNr           guifg=#b0b0b0
        highlight Visual           guibg=#e6e6e6

        " Window borders
        highlight WinSeparator     guifg=#d9d9d9
        highlight FloatBorder      guifg=#c8c8c8

        " Menus
        highlight Pmenu            guibg=#ffffff
        highlight PmenuSel         guibg=#eaeaea

        " Telescope
        highlight TelescopeNormal        guibg=NONE
        highlight TelescopePromptNormal  guibg=NONE
        highlight TelescopeResultsNormal guibg=NONE
        highlight TelescopePreviewNormal guibg=NONE
        highlight TelescopeBorder        guifg=#ccd0da
        highlight TelescopePromptBorder  guifg=#ccd0da
        highlight TelescopeResultsBorder guifg=#ccd0da
        highlight TelescopePreviewBorder guifg=#ccd0da

        " NvimTree
        highlight NvimTreeNormal    guibg=NONE
        highlight NvimTreeNormalNC  guibg=NONE
        highlight NvimTreeWinSeparator guifg=#e6e9ef
      ]])
      return
    end

    -- Keep existing overrides for dark themes
    vim.cmd([[
      highlight Comment         guifg=#ff9ac1 gui=italic
      highlight Keyword         guifg=#ff8b39 gui=bold
      highlight Function        guifg=#9aedfe gui=bold
      highlight String          guifg=#e0ff87
      highlight Type            guifg=#ffb86c
      highlight Normal          guibg=NONE
      highlight NormalNC        guibg=NONE
      highlight LineNr          guifg=#5c6370
      highlight CursorLineNr    guifg=#ff9ac1 gui=bold
      highlight Visual          guibg=#3c3c55
      highlight DiagnosticError guifg=#ff5555
      highlight DiagnosticWarn  guifg=#ffb86c
      highlight DiagnosticInfo  guifg=#8be9fd
      highlight DiagnosticHint  guifg=#50fa7b
      highlight TelescopeNormal guibg=NONE
      highlight TelescopeBorder guifg=#ff9ac1
      highlight TelescopePromptBorder   guifg=#ff8b39
      highlight TelescopeResultsBorder  guifg=#9aedfe
      highlight TelescopePreviewBorder  guifg=#e0ff87
    ]])
  end,
}
