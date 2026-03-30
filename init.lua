-- Entry point on nvim startup if you forgor

-- Basic settings that independent of plugins
require('core.options')
require('core.colorcolumn')
require('core.clipboard')
require('core.winbar').setup()
require('custom.diagnostic')

------------------------------------------------------
--                   Plugin Setup
------------------------------------------------------
--  NOTE: You can configure plugins after the setup call,
--  as they will be available in your neovim runtime.

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',                    -- telescope dep
  'https://github.com/tpope/vim-sleuth',                         -- auto indent
  'https://github.com/lewis6991/gitsigns.nvim',
  "https://github.com/folke/zen-mode.nvim",                      -- vcenter buf

  -- requires config
  "https://github.com/navarasu/onedark.nvim",
  'https://github.com/williamboman/mason.nvim',               -- Easily install LSP servers
  {
      src = 'https://github.com/nvim-telescope/telescope.nvim',
      version = '0.1.x',
  },
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'master',
  },
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range("^1"),
  }
})

  -- x require('plugins.color'),
  -- x require('plugins.ui.telescope').plugs,      -- search
  -- x require('plugins.treesitter').plugs,        -- ast hl
  -- x require('plugins.lsp').plugs,               -- LSP stuff

  -- require('plugins.blink_cmp').plugs,         -- completion

------------------------------------------------------
--                     Config
------------------------------------------------------
-- At this point, all plugins are loaded/built
-- and configurable

-- TODO:
require('plugins.lsp').config()
require('plugins.color').config()
require('plugins.telescope').config()
require('plugins.treesitter').config()
require('plugins.blink_cmp').config()


------------------------------------------------------
--                post-config things
------------------------------------------------------
require('core.keymaps')
require('custom.netrw')
require('custom.term')

-- telescope.* not working
require('custom.doc')
require('custom.git')
require('custom.quickfix')
require('custom.gpt')
require('custom.cmp')


-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

