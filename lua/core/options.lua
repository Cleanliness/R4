-- See `:help vim.o`
local opt = vim.opt
local wo = vim.wo
local g = vim.g

---------------------- General ----------------------
opt.colorcolumn    = '+1'
opt.cursorlineopt  = 'number'
opt.cursorline     = true
opt.foldlevelstart = 99
opt.foldtext       = ''
opt.helpheight     = 10
opt.showmode       = false
opt.mousemoveevent = true
opt.number         = true
opt.ruler          = true
opt.pumheight      = 16
opt.scrolloff      = 4
opt.sidescrolloff  = 8
opt.sidescroll     = 0
opt.signcolumn     = 'yes:1'
opt.splitright     = true
opt.splitbelow     = true
opt.swapfile       = false
opt.undofile       = true
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true
opt.conceallevel   = 2
opt.autowriteall   = true
opt.virtualedit    = 'block'
opt.completeopt    = 'menuone'

wo.number = true                        -- Make line numbers default
opt.hlsearch = false                    -- Set highlight on search
opt.mouse = 'a'                         -- Enable mouse mode
opt.clipboard = 'unnamedplus'           -- Sync clipboard between OS and Neovim.
opt.breakindent = true                  -- Enable break indent
opt.undofile = true                     -- Save undo history

-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = 'yes'                  -- Keep signcolumn on by default

-- Decrease update time
opt.updatetime = 350
opt.timeoutlen = 400

opt.completeopt = 'menuone,noselect'    -- Set completeopt to have a better completion experience
opt.termguicolors = true                -- NOTE: You should make sure your terminal supports this

-- tab and space
opt.tabstop = 4
opt.shiftwidth = 4

-- Leader to space
g.mapleader = " "

---------------------- Neovide ----------------------
-- https://neovide.dev/configuration.html
vim.g.neovide_scale_factor = 0.70
vim.g.neovide_scroll_animation_length = 0.15
vim.g.neovide_cursor_animation_length = 0.05

--------------------- clipboard ---------------------

-- WSL case
if vim.fn.has('wsl') == 1 then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end
