return {
  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup({})
      vim.keymap.set("n", "<leader>ww", "<cmd>ToggleWrapMode<CR>")
    end,
  },
}
