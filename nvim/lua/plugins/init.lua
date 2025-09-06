return {
  require("plugins.lsp"),
  require("plugins.formatting"),
  require("plugins.theme"),
  require("plugins.highlight"),
  require("plugins.cmp"),
  require("plugins.lint"),
  require("plugins.git"),
  require("plugins.treesitter"),
  require("plugins.ui"),
  require("plugins.whichkey"),
  -- Language specific
  require("plugins.lang.python"),
  require("plugins.lang.web"),
  require("plugins.lang.markdown"),
}
