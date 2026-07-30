vim.api.nvim_create_user_command("UpdateAll", function()
  -- Update Mason (LSPs)
  if not vim.g.minimal then
    vim.cmd("MasonUpdateAll")
  end

  -- Update Lazy plugins
  require("lazy").update({ show = false })
end, { desc = "Update Mason packages and Lazy plugins" })
