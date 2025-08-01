local create_git_usr_cmd = function(builtin)

  -- Map of git subcommands to their handlers
  local git_commands = {
    -- Telescope git builtins
    status = builtin.git_status,
    commits = builtin.git_commits,
    bcommits = builtin.git_bcommits,
    branches = builtin.git_branches,
    branch = builtin.git_branches, -- alias
    stash = builtin.git_stash,
    files = builtin.git_files,

    -- Basic git operations (non-telescope)
    commit = function(args)
      local message = args.args
      if message and message ~= "" then
        vim.cmd('!git commit -m "' .. message .. '"')
      else
        vim.cmd('!git commit')
      end
    end,

    pull = function()
      vim.cmd('!git pull')
    end,

    push = function()
      vim.cmd('!git push')
    end,
  }

  vim.api.nvim_create_user_command("Git", function(args)
    local subcommand = args.fargs[1]

    if not subcommand then
      -- Default to git status if no subcommand provided
      builtin.git_status()
      return
    end

    local handler = git_commands[subcommand]
    if handler then
      handler(args)
    else
      -- Fallback to raw git command
      vim.cmd('!git ' .. args.args)
    end
  end, {
    nargs = '*',
    complete = function()
      return vim.tbl_keys(git_commands)
    end,
  })
end

-------------------------------------------------------

local init = function()
  local builtin = require('telescope.builtin')
  if builtin == nil then
      return
  end

  create_git_usr_cmd(builtin)
end

init()

