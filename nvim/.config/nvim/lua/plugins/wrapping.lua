return {
  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup({})
      vim.keymap.set("n", "<leader>ww", ":ToggleWrapMode<CR>")
    end,
  },
}
