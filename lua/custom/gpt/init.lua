local fitm = require('custom.gpt.fitm')
fitm.setup()

vim.api.nvim_create_user_command("FitmTest", function()
  vim.print(fitm.request_completion("the capital of belarus is"))
end, {})
vim.api.nvim_create_user_command("FitmDebug", fitm.check_health, {})
vim.api.nvim_create_user_command("Fitm", function()
  vim.print(fitm.request_completion())
end, {})

