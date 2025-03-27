-- Environment switching without leaving Neovim

local plugs = {
    {
        "Cleanliness/swenv.nvim",
        dependencies = {
            'nvim-lua/plenary.nvim',
      }
    }
}

-- Called after setting a virtual environment
local _post_set_venv = function()
    vim.lsp.stop_client(vim.lsp.get_clients())
    if vim.wait(5000, function() return next(vim.lsp.get_clients()) == nil end) then
        if vim.fn.bufname("%") ~= '' then
            vim.cmd("edit")
        end
        else
            print("couldn't stop lsp")
    end
end

-- Populate list of virtual environments
local _get_venvs = function(venvs_path)
    return require('swenv.api').get_venvs(venvs_path)
end

------------------------------------------------------
--                   user commands
------------------------------------------------------
-- :Venvs - select virtual environment
local _set_user_commands = function()
    vim.api.nvim_create_user_command('Venvs', function()
        require('swenv.api').pick_venv()
    end, {})
end

------------------------------------------------------
--              post-init setup
------------------------------------------------------
local config = function ()
    require('swenv').setup({
        get_venvs = _get_venvs,
        venvs_path = vim.fn.expand('~/miniconda3/envs'),
        post_set_venv = _post_set_venv,
    })

    _set_user_commands()
end

return {
    plugs = plugs,
    config = config
}

