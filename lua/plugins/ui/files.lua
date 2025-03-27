local plugs = {
  'stevearc/oil.nvim',
  opts = {
  },
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}

local config = function()
  local oil = require("oil")
  oil.setup()

  -- open in float window
  vim.api.nvim_create_user_command("Foil", function()
      require("oil").open_float()
  end, {})

  -- open in vertical split
  vim.api.nvim_create_user_command("Voil", function()
    vim.cmd("vsplit")
    require("oil").open()
  end, {})
end


return {
  plugs = plugs,
  config = config
}
