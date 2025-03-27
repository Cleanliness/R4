-- Fuzzy Finder (files, lsp, etc)
local plugs = {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
}

------------------------------------------------------
--                    Utility 
------------------------------------------------------

-- search working directory
local search_wdir = function()
  local builtin = require('telescope.builtin')
  builtin.live_grep()
end

-- search current buffer
local search_buf = function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    previewer = true,
  })
end

-- search files in cwd
local search_files = function()
	require('telescope.builtin').find_files()
end

------------------------------------------------------
--                    Config
------------------------------------------------------
-- setup fn called
local config = function()
  local tele = require('telescope')

  tele.setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }
  vim.keymap.set('n', '<leader><space>', search_wdir, {desc = 'Live grep in working directory'})
  vim.keymap.set('n', '<leader>f', search_files, {desc = 'Search files in working dir'})
  vim.keymap.set('n', '<leader>/', search_buf, {desc = '[/] Fuzzily search in current buffer'})
end

return {
  plugs = plugs,
  config = config
}
