-- NOTE: called post-config. All plugins ready to use

--------------------------------------------------
--                   Helpers
--------------------------------------------------

local function shell_init()
  -- NOTE: this depends on _CONDA_INIT_ENV in .bashrc
  local conda_init = ""
  local conda_env = require('util.conda').get_current_env()
  if conda_env then
    conda_init = "env _CONDA_INIT_ENV=" .. conda_env .. " "
  end
  vim.o.shell = conda_init .. 'bash'
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
-- vert/horiz terminal shortcuts with bang support
-- and arg forwarding

-- open terminal in vertical split
vim.api.nvim_create_user_command('Verm', function(opts)
  local pos = opts.bang and 'leftabove vsplit' or 'vsplit'
  vim.cmd(pos .. ' | terminal ' .. opts.args)
end, { nargs = '*', bang = true })

-- open terminal in horizontal split
vim.api.nvim_create_user_command('Herm', function(opts)
  local pos = opts.bang and 'leftabove split' or 'split'
  -- vim.cmd(pos .. ' | terminal ' .. opts.args)
  vim.cmd(pos .. ' | resize ' .. math.floor(vim.o.lines * 0.25) .. ' | terminal ' .. opts.args)
end, { nargs = '*', bang = true })

shell_init()

