-- Language server protocol
-- Use language server features in Neovim
--   i.e. Code completion, go to def, find references, etc.
-- youtube.com/watch?v=HL7b63Hrc8U

-- Debugging:
--    `:LspInfo` - list all active LSP clients in curr buffer


local plugs = {
  {'neovim/nvim-lspconfig'},              -- Wraps LSP setup boilerplate
  {
    'williamboman/mason-lspconfig.nvim',  -- Interface between Mason & LSPConfig
    dependencies = {
      'williamboman/mason.nvim'           -- Easily install LSP servers
    }
  },
}

------------------------------------------------------
--                     Helpers
------------------------------------------------------

-- Highlight on hover
-- :h vim.lsp.buf.document_highlight()
local lsp_highlight_hover = function(args)
  local bufnr = args.buf
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.document_highlight()
    end
  })
  vim.api.nvim_create_autocmd('CursorHoldI', {
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

------------------------------------------------------
--                     Mason
------------------------------------------------------
-- Easily install LSP/DAP/Linters

local mason_config = function()
  local mason = require('mason')
  local mason_lspconfig = require('mason-lspconfig')

  -- mason-lspconfig requires that these setup functions are called in this order
  -- before setting up the servers.
  mason.setup({})
  mason_lspconfig.setup({
    ensure_installed = {
      'pyright',         -- MS python lsp. it just werks
      'lua_ls',
      'clangd',          -- C/C++
      'ts_ls'            -- typescript
    }
  })

  mason_lspconfig.setup_handlers({
    -- default LSP setup handler
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,

    ['pyright'] = function ()
      local lspconfig = require("lspconfig")
      lspconfig.pyright.setup({
        settings = {
          python = {
            pythonPath = "python3",           -- default to global python3
            analysis = {
              typeCheckingMode = "off",
            }
          }
        }
      })
    end
  })
end

------------------------------------------------------
--               post-init setup
------------------------------------------------------
-- This will be called after the plugins are loaded

local config = function()
  mason_config()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = lsp_highlight_hover,
  })
end

return {
  plugs = plugs,
  config = config,
}
