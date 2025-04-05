#!/bin/sh

echo "Installing fresh config to:"

NVIM_CONF=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("config"))' -c 'quit')
NVIM_STATE=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("state"))' -c 'quit')
NVIM_CACHE=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("cache"))' -c 'quit')
NVIM_DATA=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("data"))' -c 'quit')

echo "nvim conf:" $NVIM_CONF
echo "nvim state:" $NVIM_STATE
echo "nvim cache:" $NVIM_CACHE
echo "nvim data:" $NVIM_DATA

read -p "Continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then
    echo "Removing existing neovim config"
    # rm -rf $NV_STATE
    # rm -rf $NV_CACHE
    # rm -rf $NV_CONFIG
    # rm -rf $NV_DATA
    echo "Copying."
    # cp -r . ~/.config/nvim
    echo "Complete."
else
  echo "Cancelled";
fi

