apply:
	rm -rf ~/.config/nvim
	cp -r . ~/.config/nvim

size:
	du -sh $(nvim --headless -c 'lua io.write(vim.fn.stdpath("config"))' -c 'quit' 2>/dev/null)
	du -sh $(nvim --headless -c 'lua io.write(vim.fn.stdpath("state"))' -c 'quit' 2>/dev/null)
	du -sh $(nvim --headless -c 'lua io.write(vim.fn.stdpath("cache"))' -c 'quit' 2>/dev/null)
	du -sh $(nvim --headless -c 'lua io.write(vim.fn.stdpath("data"))' -c 'quit' 2>/dev/null)
