-- displaying errors or warnings from external
-- tools, otherwise known as "diagnostics". These diagnostics can
-- come from avariety of sources, such as linters or LSP servers.
-- The diagnostic framework is an extension to existing error
-- handling functionality such as the quickfix list


vim.diagnostic.config({
  severity_sort = true,
  virtual_text = false,
  -- hl_mode = 'combine'
})
