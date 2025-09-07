return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local function apply_overrides()
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

      -- Dark theme: keep colors from Catppuccin (Frappe) and only add transparency to floats/sidebars/bars
      vim.cmd([[
        " Floats
        highlight NormalFloat guibg=NONE
        highlight FloatBorder guibg=NONE

        " Telescope
        highlight TelescopeNormal        guibg=NONE
        highlight TelescopePromptNormal  guibg=NONE
        highlight TelescopeResultsNormal guibg=NONE
        highlight TelescopePreviewNormal guibg=NONE
        highlight TelescopeBorder        guibg=NONE
        highlight TelescopePromptBorder  guibg=NONE
        highlight TelescopeResultsBorder guibg=NONE
        highlight TelescopePreviewBorder guibg=NONE

        " Sidebars
        highlight NvimTreeNormal    guibg=NONE
        highlight NvimTreeNormalNC  guibg=NONE
        highlight NvimTreeWinSeparator guibg=NONE

        " Bars
        highlight StatusLine   guibg=NONE
        highlight StatusLineNC guibg=NONE
        highlight TabLine      guibg=NONE
        highlight TabLineFill  guibg=NONE
        highlight WinSeparator guibg=NONE
      ]])
    end

    -- Apply now and on colorscheme changes
    apply_overrides()
    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
      group = vim.api.nvim_create_augroup("ThemeOverrides", { clear = true }),
      callback = apply_overrides,
      desc = "Apply light/dark UI transparency tweaks",
    })
  end,
}
