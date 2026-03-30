local kmset = vim.keymap.set

------------------------------------------------------
--                 Standard keymaps
------------------------------------------------------
kmset({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
kmset('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
kmset('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
kmset('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
kmset('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
kmset('n', '<C-a>', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
kmset('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


------------------------------------------------------
--                  LSP stuff
------------------------------------------------------
-- see: https://neovim.io/doc/user/lsp.html#_defaults

-- LSP go-to-definition in a horizontal split
kmset('n', 'grh', function()
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('split')
  vim.lsp.buf.definition()

  -- If the definition is in the same file, the cursor will already be there.
  -- If it's in a different file, the split will now contain that file.
  -- If the server returned a location in the same buffer, make sure we
  -- actually moved; if not, close the redundant split.
  vim.schedule(function()
    if vim.api.nvim_get_current_win() == cur_win then
      vim.cmd('close')
    end
  end)
end, { desc = 'LSP definition (horizontal split)' })

-- LSP go-to-definition in a vertical split
kmset('n', 'grv', function()
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('vsplit')
  vim.lsp.buf.definition()
  vim.schedule(function()
    if vim.api.nvim_get_current_win() == cur_win then
      vim.cmd('close')
    end
  end)
end, { desc = 'LSP definition (vertical split)' })

------------------------------------------------------
--                    Scrollwheel
------------------------------------------------------

-- Make the wheel scroll the viewport, not the cursor
kmset('n', '<ScrollWheelUp>', '<C-Y>', { noremap = true })
kmset('n', '<ScrollWheelDown>', '<C-E>', { noremap = true })

-- same thing in visual/insert/select mode
kmset('i', '<ScrollWheelUp>', '<C-O><C-Y>', { noremap = true })
kmset('i', '<ScrollWheelDown>', '<C-O><C-E>', { noremap = true })
kmset('v', '<ScrollWheelUp>', '<C-Y>', { noremap = true })
kmset('v', '<ScrollWheelDown>', '<C-E>', { noremap = true })
kmset('s', '<ScrollWheelUp>', '<C-Y>', { noremap = true })
kmset('s', '<ScrollWheelDown>', '<C-E>', { noremap = true })


------------------------------------------------------
--                   Non-standard
------------------------------------------------------

-- TODO: buggy. gf from term has hidden lines

-- -- gf: open file under cursor in vertical split, then move split left
-- -- In terminal mode: also exit terminal first
-- kmset('t', 'gf', '<C-\\><C-n><C-w>v<C-w>Hgf<C-w>l:q<CR>', { desc = 'Open file under cursor (vertical split, from terminal)' })
-- kmset('n', 'gf', function()
--   if vim.bo.buftype == 'terminal' then
--     return '<C-w>v<C-w>Hgf<C-w>l:q<CR>'
--   else
--     return 'gf'
--   end
-- end, { expr = true, desc = 'Open file under cursor (vertical split)' })

