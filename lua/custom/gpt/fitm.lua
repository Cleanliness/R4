local state = {
  enabled = false,
  key_found = false,
  curr_endpoint = "https://codestral.mistral.ai/v1/fim/completions",
  last_req = nil
}

local curl = nil
local API_KEY = nil

--------------------------------------------------

-- configuration
local function setup()
  API_KEY = os.getenv("MISTRAL_API_KEY")
  if API_KEY then
    state.enabled = true
    state.key_found = true
  end

  curl = require("plenary.curl")
end

local function check_health()
  vim.print(state)
end

local function is_ready()
  return state.enabled or (curr_endpoint ~= nil and key_found ~= nil)
end

--------------------------------------------------
--                  Helpers
--------------------------------------------------

-- get content around cursor on current buffer
local function get_text_around_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row-1 -- buf_get_lines uses 0 indexing!!!

  local line = vim.api.nvim_get_current_line()
  local line_before = string.sub(line, 1, col)
  local line_after = string.sub(line, col + 1)

  -- [0, row) and (row, -1]
  local before = vim.api.nvim_buf_get_lines(0, 0, row, false)
  local after = vim.api.nvim_buf_get_lines(0, row+1, -1, false)

  table.insert(before, line_before)
  table.insert(after, 1, line_after)

  before = table.concat(before, "\n")
  after = table.concat(after, "\n")

  return before, after, lb, la
end

--------------------------------------------------

-- mistral fitm api boilerplate
local function codestral_call(pre, suf)

  if pre == nil and suf == nil then
    return
  end

  local headers = {
    ['Content-Type'] = 'application/json',
    ['Authorization'] = 'Bearer ' .. API_KEY,
  }

  local body = vim.fn.json_encode({
    model = "codestral-latest",
    prompt = pre,
    suffix = suf,
    max_tokens = 64,
    temperature = 0
  })

  local resp = curl.post({
    url = state.curr_endpoint,
    headers = headers,
    body = body,
    accept = "application/json"
  })

  state.last_req = resp
  if resp.status and resp.status == 200 then
    local res = vim.fn.json_decode(resp.body)
    state.last_req = res
    return res.choices[1].message.content
  end

end

--------------------------------------------------

local function request_completion()
  local pre, suf, lb, la = get_text_around_cursor()
  local res = codestral_call(pre, suf)

  -- vim.print(res)

  return res
end

return {
  setup = setup,
  request_completion = request_completion,
  check_health = check_health,
  get_text = get_text_around_cursor
}

