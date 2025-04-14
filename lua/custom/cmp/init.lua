-- :h ins-completion

local fitm = require('custom.gpt.fitm')


local function fitm_comp()
  local col = vim.fn.col('.')
  local comps = {
    {word = fitm.request_completion(), menu="[codestral]"}
  }
  vim.fn.complete(col, comps)
end

-- trigger completion
vim.keymap.set('i', '<C-x><C-a>', fitm_comp, {desc = "lm completion"})

