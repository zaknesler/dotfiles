vim.keymap.set("n", "<leader>zz", function()
  require("zen-mode").setup {
    window = {
      width = 80,
      options = {},
      backdrop = 1,
    },
  }
  require("zen-mode").toggle()
  vim.wo.wrap = false
  vim.wo.number = true
  vim.wo.rnu = true
  ApplyColor()
end)


vim.keymap.set("n", "<leader>zZ", function()
  require("zen-mode").setup {
    window = {
      width = 80,
      options = {},
      backdrop = 1,
    },
  }
  require("zen-mode").toggle()
  vim.wo.wrap = false
  vim.wo.number = false
  vim.wo.rnu = false
  vim.opt.colorcolumn = "0"
  ApplyColor()
end)
