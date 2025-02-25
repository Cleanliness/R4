local plugs = {

    {
        'saghen/blink.compat',
        version = '*',
        lazy = true,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        -- dependencies = 'rafamadriz/friendly-snippets',
        dependencies = {
            {"sourcegraph/sg.nvim"},
        },
        version = '*',
		signature = {enabled = true},
        opts = {
            keymap = { preset = 'super-tab' },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'cody', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    cody = {
                        name = "cody",
                        module = "blink.compat.source",
                        enabled = true,
                        async = true,
                    }
                }
            },
        },
        -- opts_extend = { "sources.default" }
    }
}

--------------------------------------------------

return {
    plugs = plugs
}
