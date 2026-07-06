-- Update Mason packages + Lazy plugins
vim.api.nvim_create_user_command("UpdateAll", function()
  vim.cmd("MasonUpdateAll")
  require("lazy").update({ show = false })
end, { desc = "Update Mason packages and Lazy plugins" })
