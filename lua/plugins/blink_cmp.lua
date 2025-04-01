local plugs = {
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        -- dependencies = 'rafamadriz/friendly-snippets',
        version = '*',
        signature = {enabled = true},
        opts = {
            keymap = {
                preset = 'default',
                ['<C-y>'] = { 'accept' }
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            cmdline = {
                enabled = true,
                completion = {
                    menu = {auto_show = true}
                }
            },
            completion = {
                menu = {auto_show = true}
            }
        },
    }
}

--------------------------------------------------

return {
    plugs = plugs
}
