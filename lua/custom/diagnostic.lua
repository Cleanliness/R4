-- displaying errors or warnings from external
-- tools, otherwise known as "diagnostics".
-- variety of sources: linters, LSP servers, etc.

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = false,
  -- hl_mode = 'combine'
})

-- show diagnostics
vim.api.nvim_create_user_command(
  'Diagnose',
  function(opts)
    vim.print(opts.args)
    local bufn = (opts.args and tonumber(opts.args)) or nil
    local tele = require('telescope.builtin')
    if tele then
      tele.diagnostics({bufnr = bufn})
    else
      vim.diagnostics.send_to_qflist()
    end
  end,
  { nargs = "?" }
)
