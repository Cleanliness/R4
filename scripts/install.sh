#!/bin/bash

echo "Fresh install to:"

# capture nvim paths
NVIM_CONF=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("config"))' -c 'quit' 2>/dev/null)
NVIM_STATE=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("state"))' -c 'quit' 2>/dev/null)
NVIM_CACHE=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("cache"))' -c 'quit' 2>/dev/null)
NVIM_DATA=$(nvim --headless -c 'lua io.write(vim.fn.stdpath("data"))' -c 'quit' 2>/dev/null)

echo "nvim conf:" $NVIM_CONF
echo "nvim state:" $NVIM_STATE
echo "nvim cache:" $NVIM_CACHE
echo "nvim data:" $NVIM_DATA

read -p "Continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then
    echo "Removing existing neovim config"
    rm -rf "$NVIM_STATE"
    rm -rf "$NVIM_CACHE"
    rm -rf "$NVIM_CONF"
    rm -rf "$NVIM_DATA"

    echo "Creating new config directory"
    mkdir -p "$NVIM_CONF"

    echo "Copying files..."
    cp -r . "$NVIM_CONF"

    echo "Cleaning up any .git directory"
    rm -rf "$NVIM_CONF/.git"

    echo "Installation complete!"
else
    echo "Installation cancelled"
    exit 1
fi

