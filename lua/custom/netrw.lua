vim.g.netrw_liststyle = 3       -- tree mode
vim.g.netrw_banner = 0          -- hide banner (toggle with 'I')
vim.g.netrw_winsize = 25        -- quarter width
vim.g.netrw_browse_split = 4    -- open in previous buffer
vim.g.netrw_keepdir = 0         -- don't keep directory, use cwd

-- hide dotfiles
vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'
