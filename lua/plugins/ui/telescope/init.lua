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
  local builtin = require('telescope.builtin')
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
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
  local actions = require('telescope.actions')
  local builtin = require('telescope.builtin')

  tele.setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
        n = {
          ['<C-x>'] = false,
          ['<C-v>'] = false,
          ['<C-t>'] = false,
          ['<S-x>'] = actions.select_horizontal,
          ['<S-v>'] = actions.select_vertical,
          ['<S-t>'] = actions.select_tab,
        },
      },
    },

    pickers = {
      git_status = {
        initial_mode = "normal",
      }
    }
  }

  -- keymaps
  vim.keymap.set('n', '<leader>g', search_wdir, {desc = 'Live grep in working directory'})
  vim.keymap.set('n', '<leader>f', search_files, {desc = 'Search all files in working dir'})
  vim.keymap.set('n', '<leader>F', builtin.git_files, {desc = 'Search git tracked files in working dir'})
  vim.keymap.set('n', '<leader>/', search_buf, {desc = '[/] Fuzzily search in current buffer'})
  vim.keymap.set('n', '<leader><space>', builtin.resume, {desc = 'Resume last search'})

end

return {
  plugs = plugs,
  config = config
}
