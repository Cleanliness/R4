-- fast and easy to configure Neovim statusline written in Lua 
-- `:help lualine.txt`

local plugs = {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
    },
}

return {
  plugs = plugs
}
