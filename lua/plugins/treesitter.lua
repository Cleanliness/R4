-- Treesitter is an incremental parser framework for building syntax trees
--    With this, we can **SUPPORT** highlighting, etc.
--    for arbitrary languages (provided it has a parser)
-- You can check the AST w/ `:InspectTree`

-- In short: ST-aware features:
--    syntax highlighting, linting
--    folding, indenting, etc.

-- NOTE: Treesitter api is already in neovim (try vim.treesitter)
-- We are just configuring it here

-- TODO: nvim-treesitter-textobjects?

local plugs = {
  'nvim-treesitter/nvim-treesitter',    -- Provides parsers and CST-dependent features
}

-- The most basic languages we want to support
-- NOTE: Some TreeSitter parsers depend on others to work properly
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

local config = function()
  local ts = require('nvim-treesitter.configs')
  ts.setup({
    ensure_installed = lang_base,       -- Install the base languages
    auto_install = false,               -- Auto install parser when entering a file
    highlight = { enable = true },
  })
end

return {
  plugs = plugs,
  config = config
}
