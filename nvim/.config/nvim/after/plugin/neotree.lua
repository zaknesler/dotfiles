require("neo-tree").setup({
  source_selector = {
    winbar = false,
    statusline = false
  }
})

vim.keymap.set('n', '<leader>tq', ":Neotree action=close<CR>")
vim.keymap.set('n', '<leader>t', ":Neotree<CR>")
