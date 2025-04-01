-- Use language server features in Neovim
--   i.e. Code completion, go to def, find references, etc.
--   https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#languageServerProtocol
-- Debugging:
--   `:checkhealth vim.lsp`


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

local ensure_install = function(servers)
  local mason_registry = require("mason-registry")

  for _, server in ipairs(servers) do
    if not mason_registry.is_installed(server) then
      print("[lsp.lua] installing " .. server)
      mason_registry.get_package(server):install()
    end
  end
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
  local success, res = pcall(ensure_install, config.mason_lsp)
  if not success then
    print("[lsp.lua] could not ensure lsps are installed", res)
  end

  config.apply_config()
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
