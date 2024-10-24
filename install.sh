#!/bin/sh

# fresh install
echo "Installing new neovim config"

# Get rid of old nvim config
rm -rf ~/.local/state/nvim       # stdpath('state')
rm -rf ~/.cache/nvim             # stdpath('cache')
rm -rf ~/.config/nvim            # stdpath('config')
rm -rf ~/.local/share/nvim       # stdpath('data')

# This doesn't work, not stdout (?)
# NV_STATE=$(nvim --headless -c 'echo stdpath("state")' -c 'quit')
# NV_CACHE=$(nvim --headless -c 'echo stdpath("cache")' -c 'quit')
# NV_CONFIG=$(nvim --headless -c 'echo stdpath("config")' -c 'quit')
# NV_DATA=$(nvim --headless -c 'echo stdpath("data")' -c 'quit')
# echo "Removing existing neovim config"
# rm -rf $NV_STATE
# rm -rf $NV_CACHE
# rm -rf $NV_CONFIG
# rm -rf $NV_DATA

cp -r ../R4 ~/.config/nvim
echo "Complete."
