local init_dl_toggle = function ()
  vim.keymap.set('n', '<leader>ts', function()
    vim.o.background = vim.o.background == 'light' and 'dark' or 'light'
  end, { desc = 'Toggle light/dark background' })
end

local config = function ()
  require('onedark').setup {
    toggle_style_key = "<leader>ts",
    style = "dark",
   toggle_style_list = {"light", "dark"},
    code_style = {
      comments = 'none',
      keywords = 'none',
      functions = 'none',
      strings = 'none',
      variables = 'none'
    },
  }

  -- Enable theme
  require('onedark').load()
end

return {
  "navarasu/onedark.nvim",
  priority = 1000, -- make sure to load this before all the other start plugins
  config = config
}
