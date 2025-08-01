local providers = {
  -- fitm = {
  --     module = "custom.gpt.blink_fitm_source",
  --     async = true,
  -- }
}

local plugs = {
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        -- dependencies = 'rafamadriz/friendly-snippets',
        version = '*',
        signature = {enabled = true},
        opts = {
            keymap = {
                preset = 'super-tab',
                ['<C-y>'] = { 'accept' }
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = {
                    -- broken: 'fitm',
                    'lsp',
                    'path',
                    'snippets',
                    'buffer'
                },
                providers = providers,
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

