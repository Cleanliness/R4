-- Entry point on nvim startup if you forgor

-- Basic settings that don't require plugins
require('core.options')
require('core.colorcolumn')
require('core.clipboard')
require('core.winbar').setup()
require('custom.diagnostic')

------------------------------------------------------
--                  init Lazy.nvim
------------------------------------------------------
-- this concats lazy.nvim to stdpath
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then     -- first time clone
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)              -- this ensures require('lazy') works


------------------------------------------------------
--                   Plugin Setup
------------------------------------------------------
--  NOTE: You can configure plugins after the setup call,
--  as they will be available in your neovim runtime.

require('lazy').setup({
  'tpope/vim-sleuth',
  'lewis6991/gitsigns.nvim',

  require('plugins.color'),
  require('plugins.ui.telescope').plugs,      -- search
  require('plugins.treesitter').plugs,        -- highlighting and more 
  require('plugins.lsp').plugs,               -- LSP stuff
  require('plugins.blink_cmp').plugs,         -- completion
}, {})

------------------------------------------------------
--                     Config
------------------------------------------------------
-- At this point, all plugins are loaded/built 
-- and you can now configure them

require('plugins.lsp').config()
require('plugins.ui.telescope').config()
require('plugins.treesitter').config()

------------------------------------------------------
--                post-config things
------------------------------------------------------
-- Things that should happen after the plugins are fully
-- loaded and configured

require('core.keymaps')
require('custom.netrw')
require('custom.term')
require('custom.doc')
require('custom.quickfix')
require('custom.gpt')
require('custom.cmp')
require('custom.git')


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

