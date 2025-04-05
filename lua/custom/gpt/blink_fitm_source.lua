local blink_types = require('blink.cmp.types')
local fitmlib = require('custom.gpt.fitm')

local M = {}
local i = 0
local T_QUANTA = 1000

--------------------------------------------------

-- constructor
function M:new(opts)
  local self = setmetatable({}, { __index = M })
  self.dt = 0
  self.timer = nil
  self.items = {}

  return self
end

-- this gets called on every keypress
function M:get_completions(ctx, callback)

  -- restart cooldown timer if interrupted
  if self.timer then
    vim.uv.timer_stop(self.timer)
    self.timer = nil
    return
  end

  self.timer = vim.uv.new_timer()
  self.timer:start(T_QUANTA, 0, vim.schedule_wrap(function()
    callback({
      items = self.exec_completion(ctx),
      is_incomplete_backward = false,
      is_incomplete_forward = true,
    })
  end))
end

function M:exec_completion(ctx)
  vim.print("[fitm-blink] get completions called " .. i)
  i = i + 1

  local item = {
    label = fitmlib.request_completion,
    kind = blink_types.CompletionItemKind.Text,
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
  }
  local items = {}

  if item.label then
    table.insert(items, item)
  end

  return items
end

-- Called immediately after applying the item's textEdit/insertText
function M:execute(ctx, item, callback, default_implementation)
  default_implementation()
  callback()
end

return M
