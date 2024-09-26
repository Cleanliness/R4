-- TODO: This is a bit of a mess, need to clean up

local plugs = {
    -- Interfaces with nvim's completion API,
    -- manages for completion sources + allows you
    -- to customize completion behavior
    {
        'hrsh7th/nvim-cmp',
    }, 
    -- snippets
    {'hrsh7th/cmp-vsnip'},                      -- vsnip source
    {'hrsh7th/vim-vsnip'},                      -- snippet engine

    -- cmp sources
    {'hrsh7th/cmp-buffer'},                     -- Buffer completion
    {'hrsh7th/cmp-nvim-lsp'},                   -- LSP completion
}

local cmp_expand_fn = function(args)
    vim.fn["vsnip#anonymous"](args.body)
end

local config = function()
    local cmp = require('cmp')
    cmp.setup({
        snippet = {
            expand = cmp_expand_fn,
        },
        sources = {
            {name = 'vsnip'},
            {name = 'buffer'},
            {name = 'nvim_lsp'},
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = {
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
    })
end

return {
    plugs = plugs,
    config = config,
}
