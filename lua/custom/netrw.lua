-- Netrw configuration
vim.g.netrw_liststyle = 3             -- tree mode
vim.g.netrw_banner = 0                -- hide banner (toggle with 'I')
vim.g.netrw_winsize = 25              -- quarter width
vim.g.netrw_browse_split = 4          -- open in previous buffer
vim.g.netrw_keepdir = 0               -- don't keep directory, use cwd
vim.g.netrw_localcopydircmd = 'cp -r' -- enable recursive copying

-- Hide dotfiles by default (toggle with 'gh')
vim.g.netrw_list_hide = [[^\.\./$,^\./$,^\.git/$,^\.DS_Store$,.*\.swp$,^\.\S\+[^/]$]]

-- Better sorting (toggle with 's')
vim.g.netrw_sort_sequence = [[[\/]$,*,\.[a-z],\.md$,\.txt$,\.c$,\.cpp$,\.h$,\.lua$]]

-- Mouse support
vim.g.netrw_mouse = 2           -- enable mouse support

-- Preview files in vertical split (toggle with 'p')
vim.g.netrw_preview = 1
vim.g.netrw_alto = 1            -- preview on left side (changed from 0 to 1)

-- Percentage size for preview window
vim.g.netrw_preview_winsize = 30 -- preview window size

-- Use more human-readable file sizes
vim.g.netrw_sizestyle = 'H'     -- Human-readable (KB, MB, GB)

-- Quick directory navigation
vim.g.netrw_quick_look = 'ql'   -- quick look command (macOS)
vim.g.netrw_use_errorwindow = 0 -- don't use error window

-- Open netrw on the left by default
vim.g.netrw_altv = 0            -- open splits to the left (changed from default)

