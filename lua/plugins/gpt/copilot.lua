-- chat/text completion with GPTs
-- TODO: Add a fast way to change endpoints

local plugs = {
    {"github/copilot.vim"},
}


-- This doesn't work right now
local config = function()
    -- vim.keymap.set("<M-\\>", '<Plug>(copilot-suggest)', {noremap = false})
end

return {
    plugs = plugs,
    config = config, 
}
