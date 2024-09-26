-- Treesitter is an incremental parser providing a framework
-- for building syntax trees
--    With this, we can **SUPPORT** highlighting, etc.
--    for arbitrary languages (provided it has a parser)
-- You can check the AST w/ `:InspectTree`

-- TLDR: AST-aware features:
--    syntax highlighting, linting
--    folding, indenting, etc.

-- NOTE: Treesitter is already in neovim (try vim.treesitter)
-- We are just configuring it here

-- TODO: nvim-treesitter-textobjects?

local plugs = {
  'nvim-treesitter/nvim-treesitter',    -- Provides parsers and CST-dependent features
}

-- The most basic languages we want to support
local lang_base = {
  "c",
  "lua",
  "vim",
  "vimdoc",
  "cpp",
  "cuda",
  "python",
  "typescript",
}

local TSconfig = function()
  local ts = require('nvim-treesitter.configs')
  ts.setup({
    ensure_installed = lang_base,       -- Install the base languages
    auto_install = false,               -- Auto install parser when entering a file
    highlight = { enable = true },
  })
end

return {
  plugs = plugs,
  TSconfig = TSconfig
}
