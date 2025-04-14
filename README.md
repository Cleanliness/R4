# R4
Tiny neovim setup. Tried to make everything as readable/modular as possible, in case I come back to this in the future. Runs smoothly on my potato i5 laptop, so it should be fine for most people.

## Dependencies
- Neovim >= 0.11
- git
- ripgrep (telescope)

### Things needed by nvim-treesitter and LSP:
Adds a huge amount of dependencies. Until I find a way to cut this down, you'll need to install these.
- watch for wasm parser integration https://github.com/neovim/neovim/pull/28415

**Building treesitter parsers**:
- A C compiler and libstdc++
- unzip

**Running LSPs**:
- node+npm
- python3

## Installation
Note: this is destructive

```
sh install.sh
```

## Post-install setup
Things that need to be done after running the install script.
- None for now

## Features
Tracking to remember what I've added.

### With Plugins (9)
- TS parser installation for highlighting
- LSP via mason
- LSP-based autocompletion
- Telescope picker for pydoc/man

### My stuff

in `lua/custom` and `lua/core`
**netrw**
- tree style display

**LM completions**
- basic endpoint manager for prefix-suffix completions
- fitm-style completion via `vim.fn.complete`

**Integrated Terminal**
- QOL improvements (auto enter insert mode in term)
- Removes line number tray
- User commands for opening in a split (`Verm`, `Herm`)

