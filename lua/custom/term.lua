-- NOTE: called post-config. All plugins ready to use

--------------------------------------------------
--                   Helpers
--------------------------------------------------

-- activate conda environment given term buffer
-- and environment name
local _activate_conda_env = function(bufnr, env)
  local chan_id = vim.bo[bufnr].channel
  if env and chan_id then
    vim.api.nvim_chan_send(chan_id, string.format('conda activate %s\n', env))
    vim.api.nvim_chan_send(chan_id, "clear\n")
  end
end

--------------------------------------------------
--              Auto commands
--------------------------------------------------

-- terminal buffer options
vim.api.nvim_create_autocmd({"TermOpen"}, {
  callback = function(args)
    -- appearance
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"

    local curr_env = require('util.conda').current_env()
    if curr_env then
      _activate_conda_env(args.buf, curr_env)
    end

    -- qol
    vim.cmd([[ startinsert ]])        -- auto enter terminal insert mode
  end,
})

-- entering terminal
vim.api.nvim_create_autocmd({"TermEnter", "BufEnter"}, {
  pattern = { "term://*" },           -- match terminal buffers
  callback = function()
    vim.cmd([[ startinsert ]])        -- auto enter terminal insert mode
  end,
})

--------------------------------------------
--             User Commands
--------------------------------------------

-- open terminal in vertical split
vim.api.nvim_create_user_command('Verm', function()
  vim.cmd('vsplit | terminal')
end, {})

-- open terminal in horizontal split
vim.api.nvim_create_user_command('Herm', function()
  vim.cmd('split | terminal')
end, {})
