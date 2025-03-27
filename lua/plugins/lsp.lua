-- Use language server features in Neovim
--   i.e. Code completion, go to def, find references, etc.
--   https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#languageServerProtocol
--   youtube.com/watch?v=HL7b63Hrc8U
-- Debugging:
--    `:checkhealth vim.lsp`


-- Note: requires git, curl/wget, unzip, tar, gzip
-- see :h mason-requirements
local plugs = {
  {'williamboman/mason.nvim'},           -- Easily install LSP servers
}

------------------------------------------------------
--                     Helpers
------------------------------------------------------
local map = function(type, key, value)
  vim.api.nvim_buf_set_keymap(0,type,key,value,{noremap = true, silent = true});
end

------------------------------------------------------
--                       lsp
------------------------------------------------------
-- Highlight on hover
-- :h vim.lsp.buf.document_highlight()
local init_lsp_highlight_hover = function(args)
  local bufnr = args.buf
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.document_highlight()
    end
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.clear_references()
    end
  })
end


local lsp_attach = function(args)
  init_lsp_highlight_hover(args)

  -- ctrl+O to jump back
  map('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
end

------------------------------------------------------
--                     Mason
------------------------------------------------------
-- Easily install LSP/DAP/Linters

local mason_config = function()
  local config = require('plugins/lsp/lspconfig')
  local mason = require('mason')

  mason.setup({
    install_root_dir = config.lsp_path
  })

  config.apply_config()
  print("lsp path:" .. config.lsp_path)
end

------------------------------------------------------
--               post-init setup
------------------------------------------------------
-- This will be called after the plugins are loaded

local config = function()
  mason_config()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = lsp_attach,
  })
end

return {
  plugs = plugs,
  config = config,
}
