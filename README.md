# R4
Tiny neovim setup. Tried to make everything as readable/modular as possible, in case I come back to this in the future. Runs smoothly on my potato i5 laptop, so it should be fine for most people.

## Dependencies
- Neovim >= 0.9
- git
- ripgrep (telescope)
- sshfs (remote editing)

### Things needed by nvim-treesitter and LSP:
For AST and LSP related features. Adds a huge amount of dependencies. Until I find a way to cut this down, you'll need to install these.
- watch for wasm parser integration https://github.com/neovim/neovim/pull/28415

**Building treesitter parsers**:
- A C compiler and libstdc++
- unzip

**Running LSP**:
- nodejs
- npm
- python3

## Installation
```
sh install.sh
```

## Post-install setup
Things that need to be done after running the install script.

### LM completions



## Features
Tracking to remember what I've added.

### From Plugins
- TS parser installation for highlighting
- Autocompletion from blink nvim
- File tree via nvim-tree + keybinds
- LSP via mason/lspconfig
- Telescope for fuzzy finding + keybinds
- Statusline via Lualine
- text completion

### My stuff

**Integrated Terminal**
- QOL improvements (auto enter insert mode in term)
- User commands for opening in a split

# TODO
- [ ] resource monitor
- [ ] remote
