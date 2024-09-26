local plugs = {
  {"nvim-tree/nvim-tree.lua"},    -- File explorer   `:help nvim-tree`
}

local nvim_tree_pre = function()
  -- netrw needs to be disabled
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

local nvim_tree_on_attach = function(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '.', api.tree.change_root_to_node, opts('CD'))
end

local nvim_tree_config = function()
  local nv_tree = require("nvim-tree")
  nv_tree.setup({
    view = {
      width = 30,
    },
    on_attach = nvim_tree_on_attach,
    filters = {
      enable = false,
    },

    -- if you want to use netrw features still
    -- disable_netrw = false,
    -- hijack_netrw = true,
  })
  ---------------- Commands and keybindings ----------------
  -- Rebind netrw commands to nvim-tree analogues
  vim.api.nvim_create_user_command('Vex', function()
    vim.cmd('NvimTreeToggle')
  end, {})

end

return {
    plugs = plugs,
    config = nvim_tree_config,
    pre = nvim_tree_pre
}
