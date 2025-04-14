local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")


local function dispatch_search(prompt)
  if not prompt or prompt == "" then
    return nil
  end

  -- TODO: this is a hack, and slow
  return {"sh", "-c", "echo " .. vim.fn.shellescape(prompt)}
end

--------------------------------------------------

-- define preview window
local function preview_def(self, entry, status)
  if not vim.fn.has("pydoc") then
    print("pydoc not available")
    return
  end
  local cmd = {"pydoc", entry.value}
  vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {"Loading..."})
  vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "man")
  vim.api.nvim_buf_set_option(self.state.bufnr, "wrap", true)        -- Enable text wrapping
  vim.api.nvim_buf_set_option(self.state.bufnr, "linebreak", true)   -- Break at word boundaries

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, data)
      else
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {"No documentation found."})
      end
    end,
    })
end

--------------------------------------------------

-- TODO: custom prefixes
-- e.g. man pages, etc.
local function doc_search()
  pickers.new({}, {
    prompt_title = "Doc Search",
    finder = finders.new_async_job({command_generator = dispatch_search}),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_buffer_previewer({
      define_preview = preview_def,
    }),
  }):find()
end



vim.keymap.set("n", "<leader>d", function()
  doc_search()
end, { noremap = true, silent = true })

