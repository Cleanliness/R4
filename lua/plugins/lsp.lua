-- code intelligence stuff
--   i.e. completion, go to def, find references, etc.
--   https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#languageServerProtocol
-- Debugging:
--   `:checkhealth vim.lsp`

------------------------------------------------------
--                     Helpers
------------------------------------------------------

local keymap = function(type, key, value)
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


-- local function init_lsp_completion(args)
--   local client = vim.lsp.get_client_by_id(args.data.client_id)
--   if not client:supports_method('textDocument/completion') then
--     return
--   end
--
--   vim.lsp.completion.enable(
--     true, client.id, args.buf, {
--       autotrigger = true,
--       convert = function(item)
--         return { abbr = item.label:gsub('%b()', '') }
--       end,
--     }
--   )
-- end

------------------------------------------------------

local function on_lsp_attach(args)
  init_lsp_highlight_hover(args)
  -- init_lsp_completion(args)

  -- ctrl+O to jump back
  keymap('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
  keymap('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
end

------------------------------------------------------
--               post-init setup
------------------------------------------------------
-- This will be called after the plugins are loaded

local config = function()
  local config = require('plugins/lsp/lspconfig')
  config.apply_config()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = on_lsp_attach,
  })
end

return {
  config = config,
}

