-- Entry point on nvim startup if you forgor

-- Pre setup things
require('plugins.ui.filetree').pre()

-- Basic settings that don't require plugins
require('core.options')

------------------------------------------------------
--                  init Lazy.nvim 
------------------------------------------------------
-- concat lazy.nvim to stdpath
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
--                      Setup
------------------------------------------------------
--  NOTE: You can configure plugins after the setup call,
--  as they will be available in your neovim runtime.

require('lazy').setup({
  'tpope/vim-fugitive',                    -- git commands in nvim
  'tpope/vim-sleuth',                      -- auto detect indent style 
  {"nvim-tree/nvim-web-devicons"},

  ---------------- Everything else --------------------
  require('plugins.telescope').plugs,      -- fuzzy finder
  require('plugins.treesitter').plugs,     -- highlighting and more 
  require('plugins.lsp').plugs,            -- all LSP stuff
  require('plugins.cmp').plugs,            -- completion

  -- AI
  require('plugins.gpt.copilot').plugs,    -- AI completion

  -- UI
  require('plugins.ui.lualine').plugs,     -- statusline
  require('plugins.ui.filetree').plugs,    -- file explorer
  require('plugins.ui.outline').plugs,     -- code outline
}, {})

------------------------------------------------------
--                     Config
------------------------------------------------------
-- At this point, all plugins are loaded/built 
-- and you can now configure them

vim.cmd [[ colorscheme minilight ]]
require('plugins.lsp').config()
require('plugins.ui.filetree').config()
require('plugins.cmp').config()
require('plugins.gpt.copilot').config()

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader><space>', builtin.live_grep, {desc = 'Live grep in working directory'})
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

-- Configure treesitter
require('plugins.treesitter').TSconfig()


------------------------------------------------------
--                post-config things
------------------------------------------------------
-- Things that should happen after the plugins are fully
-- loaded and configured

require('core.keymaps')
require('custom.term')

