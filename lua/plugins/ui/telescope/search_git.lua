-- NOTE: should only be called after plugins are loaded
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

--------------------------------------------------

local preview_def = function(self, entry, status)
  vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {"Loading..."})
  -- Extract filename from git status output
  local cmd = { "git", "diff", entry.value:sub(4) }

  local output = {}
  local handle = io.popen(table.concat(cmd, " "))
  if handle then
    for line in handle:lines() do
      table.insert(output, line)
    end
    handle:close()
  end

  vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, output)
end

--------------------------------------------------

local search_git_status = function()
  local handle = io.popen('git status --porcelain')
  local result = handle:read("*a")

  local lines = {}
  for line in result:gmatch("[^\n]+") do
    table.insert(lines, line)
  end

  pickers.new({}, {
    prompt_title = "Git Status",
    finder = finders.new_table {
        results = lines
    },
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer {
      define_preview = preview_def
    },
  }):find()
end

--------------------------------------------------

return {
  search_git_status = search_git_status,
}
