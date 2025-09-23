local M = {
  has_conda = vim.fn.executable == 1
}

--------------------------------------------------
-- Return the name of the current conda 
-- environment, or nil
--------------------------------------------------
function M.get_current_env()
  if not M.has_conda then return nil end

  -- fastest method
  local conda_env = vim.fn.getenv('CONDA_DEFAULT_ENV')
  if conda_env and conda_env ~= vim.NIL and conda_env ~= '' then
    return conda_env
  end

  -- method 2
  local conda_prefix = vim.fn.getenv('CONDA_PREFIX')
  if conda_prefix and conda_prefix ~= vim.NIL and conda_prefix ~= '' then
    local env_name = conda_prefix:match('([^/\\]+)$')
    if env_name and env_name ~= '' then
      return env_name
    end
  end

  -- Note: this approach is really slow, so last resort
  local handle = io.popen('conda info --json 2>/dev/null')
  if handle then
    local result = handle:read('*a')
    handle:close()

    if result and result ~= '' then
      local success, json = pcall(vim.fn.json_decode, result)
      if success and json and json.active_prefix then
        -- Extract environment name from active_prefix path
        local env_name = json.active_prefix:match('([^/\\]+)$')
        if env_name and env_name ~= '' then
          return env_name
        end
      end
    end
  end

  return nil  -- should rarely happen
end

--------------------------------------------------

-- Helper function to get the current shell
local function get_shell()
  return os.getenv("SHELL") or "/bin/bash"
end

-- Helper function to parse environment variables from shell output
local function parse_env_vars(output)
  local env_vars = {}
  for line in output:gmatch("[^\r\n]+") do
    local key, value = line:match("^([^=]+)=(.*)$")
    if key and value then
      -- Remove quotes if present
      value = value:gsub("^['\"](.+)['\"]$", "%1")
      env_vars[key] = value
    end
  end
  return env_vars
end

-- Main function to activate conda environment
function M.activate_conda_env(env_name)
  if not env_name or env_name == "" then
    print("Error: Please specify a conda environment name")
    return false
  end
  
  local shell = get_shell()
  
  -- Build the command to activate conda and dump environment variables
  -- We need to source conda's shell integration and then activate
  local conda_init_script = ""
  
  -- Try to find conda installation
  local conda_base = os.getenv("CONDA_PREFIX") or 
                     os.getenv("CONDA_EXE") and os.getenv("CONDA_EXE"):match("^(.*)/bin/conda$") or
                     os.getenv("HOME") .. "/miniconda3"
  
  -- Determine shell-specific conda initialization
  if shell:match("zsh$") then
    conda_init_script = conda_base .. "/etc/profile.d/conda.sh"
  elseif shell:match("bash$") then
    conda_init_script = conda_base .. "/etc/profile.d/conda.sh"
  elseif shell:match("fish$") then
    conda_init_script = conda_base .. "/etc/fish/conf.d/conda.fish"
  else
    conda_init_script = conda_base .. "/etc/profile.d/conda.sh"
  end
  
  -- Build the command
  local cmd
  if shell:match("fish$") then
    cmd = string.format(
      '%s -c "source %s; conda activate %s; env"',
      shell, conda_init_script, env_name
    )
  else
    cmd = string.format(
      '%s -c "source %s && conda activate %s && env"',
      shell, conda_init_script, env_name
    )
  end
  
  print("Activating conda environment: " .. env_name)
  
  -- Execute the command and capture output
  local handle = io.popen(cmd .. " 2>/dev/null")
  if not handle then
    print("Error: Failed to execute conda activation command")
    return false
  end
  
  local output = handle:read("*a")
  local success = handle:close()
  
  if not success or not output or output == "" then
    print("Error: Failed to activate conda environment '" .. env_name .. "'")
    print("Make sure the environment exists and conda is properly installed")
    return false
  end
  
  -- Parse and set environment variables
  local env_vars = parse_env_vars(output)
  local updated_vars = {}
  
  for key, value in pairs(env_vars) do
    -- Update Neovim's environment
    vim.env[key] = value
    table.insert(updated_vars, key)
  end
  
  -- Verify activation by checking key conda variables
  local conda_env = vim.env.CONDA_DEFAULT_ENV
  local conda_prefix = vim.env.CONDA_PREFIX
  
  if conda_env and conda_prefix then
    print("Successfully activated conda environment: " .. conda_env)
    print("Conda prefix: " .. conda_prefix)
    print("Updated " .. #updated_vars .. " environment variables")
    
    -- Update PATH for any LSP servers or external tools
    if vim.env.PATH then
      vim.env.PATH = vim.env.PATH
    end
    
    return true
  else
    print("Warning: Conda environment variables not found after activation")
    return false
  end
end

-- Function to deactivate conda environment
function M.deactivate_conda_env()
  local shell = get_shell()
  
  -- Get base environment variables
  local cmd = string.format('%s -c "env"', shell)
  local handle = io.popen(cmd)
  
  if not handle then
    print("Error: Failed to get base environment")
    return false
  end
  
  local output = handle:read("*a")
  handle:close()
  
  local base_env = parse_env_vars(output)
  
  -- Reset environment variables to base state
  for key, value in pairs(base_env) do
    vim.env[key] = value
  end
  
  -- Remove conda-specific variables
  vim.env.CONDA_DEFAULT_ENV = nil
  vim.env.CONDA_PREFIX = nil
  vim.env.CONDA_PROMPT_MODIFIER = nil
  
  print("Deactivated conda environment")
  return true
end

-- Function to show current conda environment
function M.show_conda_env()
  local conda_env = vim.env.CONDA_DEFAULT_ENV
  local conda_prefix = vim.env.CONDA_PREFIX
  
  if conda_env and conda_prefix then
    print("Current conda environment: " .. conda_env)
    print("Conda prefix: " .. conda_prefix)
  else
    print("No conda environment currently active")
  end
end

-- Function to list available conda environments
function M.list_conda_envs()
  local cmd = "conda env list --json 2>/dev/null"
  local handle = io.popen(cmd)
  
  if not handle then
    print("Error: Cannot list conda environments (conda not found)")
    return
  end
  
  local output = handle:read("*a")
  handle:close()
  
  if output and output ~= "" then
    -- Simple parsing of JSON output to extract environment names
    local envs = {}
    for env_path in output:gmatch('"([^"]*)"') do
      if env_path:match("/envs/") then
        local env_name = env_path:match("/envs/([^/]+)$")
        if env_name then
          table.insert(envs, env_name)
        end
      elseif env_path:match("/miniconda3$") or env_path:match("/anaconda3$") then
        table.insert(envs, "base")
      end
    end
    
    if #envs > 0 then
      print("Available conda environments:")
      for _, env in ipairs(envs) do
        print("  " .. env)
      end
    else
      print("No conda environments found")
    end
  else
    -- Fallback to simple conda env list
    local simple_cmd = "conda env list"
    local simple_handle = io.popen(simple_cmd)
    if simple_handle then
      local simple_output = simple_handle:read("*a")
      simple_handle:close()
      print("Conda environments:")
      print(simple_output)
    end
  end
end

--------------------------------------------------

-- Create user commands for easy access
vim.api.nvim_create_user_command('CondaActivate', function(opts)
  M.activate_conda_env(opts.args)
end, {
  nargs = 1,
  desc = 'Activate a conda environment',
  complete = function()
    -- Simple completion - you could enhance this to actually list conda envs
    return {'base'}
  end
})

vim.api.nvim_create_user_command('CondaDeactivate', function()
  M.deactivate_conda_env()
end, {
  nargs = 0,
  desc = 'Deactivate current conda environment'
})

vim.api.nvim_create_user_command('CondaShow', function()
  M.show_conda_env()
end, {
  nargs = 0,
  desc = 'Show current conda environment'
})

vim.api.nvim_create_user_command('CondaList', function()
  M.list_conda_envs()
end, {
  nargs = 0,
  desc = 'List available conda environments'
})

return M

