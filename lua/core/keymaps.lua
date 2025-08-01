------------------------------------------------------
--                 Standard keymaps
------------------------------------------------------
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<C-a>', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


------------------------------------------------------
--                    Scrollwhell
------------------------------------------------------

-- Make the wheel scroll the viewport, not the cursor
vim.keymap.set('n', '<ScrollWheelUp>', '<C-Y>', { noremap = true })
vim.keymap.set('n', '<ScrollWheelDown>', '<C-E>', { noremap = true })

-- same thing in visual/insert/select mode
vim.keymap.set('i', '<ScrollWheelUp>', '<C-O><C-Y>', { noremap = true })
vim.keymap.set('i', '<ScrollWheelDown>', '<C-O><C-E>', { noremap = true })
vim.keymap.set('v', '<ScrollWheelUp>', '<C-Y>', { noremap = true })
vim.keymap.set('v', '<ScrollWheelDown>', '<C-E>', { noremap = true })
vim.keymap.set('s', '<ScrollWheelUp>', '<C-Y>', { noremap = true })
vim.keymap.set('s', '<ScrollWheelDown>', '<C-E>', { noremap = true })
