return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- LSP source
      "hrsh7th/cmp-nvim-lsp",

      -- Snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Extra sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- (optional) load ready snippets if you install them later:
      -- require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        completion = { completeopt = "menu,menuone,noselect" },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          -- open the menu when you want
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),

          -- Enter confirms (without auto-selecting)
          ["<CR>"] = cmp.mapping.confirm({ select = false }),

          -- Tab/S-Tab navigates the menu OR snippets; doesn't interfere with AI
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- PRIORITY: LSP > snippets > path > buffer
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "path",     priority = 250 },
          { name = "buffer",   priority = 100 },
        }),

        -- small visual/UX improvements
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          format = function(entry, item)
            -- show the completion source (for quick mental debug)
            local menu = {
              nvim_lsp = "[LSP]",
              luasnip  = "[SNIP]",
              path     = "[PATH]",
              buffer   = "[BUF]",
            }
            item.menu = menu[entry.source.name]
            return item
          end,
        },
      })
    end,
  },
}
