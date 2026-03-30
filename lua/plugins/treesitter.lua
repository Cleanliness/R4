-- glue for treesitter api already in nvim (vim.treesitter)
-- ST-aware features
--    syntax highlighting, linting
--    folding, indenting, etc.
-- check w/ `:InspectTree`


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
    indent = { enable = true }
  })
end

--------------------------------------------------

--https://github.com/nvim-treesitter/nvim-treesitter/discussions/7901
return {
  config = config
}

