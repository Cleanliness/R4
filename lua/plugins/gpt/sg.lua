-- chat/text completion with GPTs
-- TODO: Add a fast way to change endpoints

local plugs = {
    {"sourcegraph/sg.nvim"},
}

local config = function()
    local sg = require("sg")
    sg.setup({})
end

return {
    plugs = plugs,
    config = config,
}
