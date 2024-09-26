--------------------------------------------
--              Auto commands
--------------------------------------------

-- terminal buffer options
vim.api.nvim_create_autocmd({"TermOpen"}, {
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.signcolumn = "no"

		vim.cmd([[ startinsert ]])  	-- auto enter terminal insert mode
	end,
})

-- entering terminal
vim.api.nvim_create_autocmd({"TermEnter", "BufEnter"}, {
	pattern = { "term://*" },			-- match terminal buffers
	callback = function()
		vim.cmd([[ startinsert ]])  	-- auto enter terminal insert mode
	end,
})

--------------------------------------------
-- 	       User Commands
--------------------------------------------

-- open terminal in vertical split
vim.api.nvim_create_user_command('Verm', function()
	vim.cmd('vsplit | terminal')
end, {})

-- open terminal in horizontal split
vim.api.nvim_create_user_command('Herm', function()
	vim.cmd('split | terminal')
end, {})
