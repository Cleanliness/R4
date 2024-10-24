-- Environment switching without leaving Neovim

local plugs = {
    {
        "AckslD/swenv.nvim",
        dependencies = {
            'nvim-lua/plenary.nvim',
      }
    }
}

-- Called after setting a virtual environment
local _post_set_venv = function()
    vim.cmd('LspRestart')

    -- make terminal use the new virtual environment

end

-- Populate list of virtual environments
local _get_venvs = function(venvs_path)
    return require('swenv.api').get_venvs(venvs_path)
end

------------------------------------------------------
--                   user commands
------------------------------------------------------
-- :venvs - select virtual environment
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
