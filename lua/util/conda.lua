local M = {}

--------------------------------------------------
-- Return the name of the current conda 
-- environment, or nil
--------------------------------------------------
function M.current_env()
  if vim.fn.executable('conda') == 0 then
    return nil
  end

  -- 1. fastest method
  local conda_env = vim.fn.getenv('CONDA_DEFAULT_ENV')
  if conda_env and conda_env ~= vim.NIL and conda_env ~= '' then
    return conda_env
  end

  -- 2. use conda prefix
  local conda_prefix = vim.fn.getenv('CONDA_PREFIX')
  if conda_prefix and conda_prefix ~= vim.NIL and conda_prefix ~= '' then
    local env_name = conda_prefix:match('([^/\\]+)$')
    if env_name and env_name ~= '' then
      return env_name
    end
  end

  -- 3. Parse conda info output
  -- Note: this is really slow
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

return M

