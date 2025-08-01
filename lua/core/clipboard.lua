-- syncing with system clipboard is a surprisingly non-trivial task
-- remove this when it just werks

-- Clipboard configuration with better detection logic
local function setup_clipboard()
    -- Default to unnamedplus if available
    vim.g.clipboard = {
        name = 'unnamedplus',
        copy = {
            ['+'] = 'unnamedplus',
            ['*'] = 'unnamedplus',
        },
        paste = {
            ['+'] = 'unnamedplus',
            ['*'] = 'unnamedplus',
        },
    }

    -- Check for WSL (Windows Subsystem for Linux)
    if vim.fn.has('wsl') == 1 then
        -- Check if clip.exe and powershell are available
        if vim.fn.executable('clip.exe') == 1 and vim.fn.executable('powershell.exe') == 1 then
            vim.g.clipboard = {
                name = 'WslClipboard',
                copy = {
                    ['+'] = 'clip.exe',
                    ['*'] = 'clip.exe',
                },
                paste = {
                    ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                    ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                },
                cache_enabled = 0,
            }
            return
        end

    -- Check for macOS
    elseif vim.fn.has('mac') == 1 then
        if vim.fn.executable('pbcopy') == 1 and vim.fn.executable('pbpaste') == 1 then
            vim.g.clipboard = {
                name = 'macOS-clipboard',
                copy = {
                    ['+'] = 'pbcopy',
                    ['*'] = 'pbcopy',
                },
                paste = {
                    ['+'] = 'pbpaste',
                    ['*'] = 'pbpaste',
                },
                cache_enabled = 1,
            }
            return
        end
    end

    -- Fallback to OSC52 if nothing else is available
    vim.g.clipboard = "osc52"
end

--------------------------------------------------

setup_clipboard()

-- Ensuring yank goes to system clipboard
-- Normal mode yanking
vim.keymap.set('n', 'y', '"+y')
vim.keymap.set('n', 'yy', '"+yy')
vim.keymap.set('n', 'Y', '"+Y')

-- Visual mode yanking
vim.keymap.set('v', 'y', '"+y')
vim.keymap.set('v', 'Y', '"+Y')

-- With motions/text objects (operator-pending mode)
vim.keymap.set('n', 'yiw', '"+yiw')  -- Yank inner word
vim.keymap.set('n', 'yaw', '"+yaw')  -- Yank a word (including surrounding whitespace)
vim.keymap.set('n', 'yi"', '"+yi"')  -- Yank inside quotes
vim.keymap.set('n', 'ya"', '"+ya"')  -- Yank around quotes

