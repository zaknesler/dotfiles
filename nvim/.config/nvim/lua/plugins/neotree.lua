return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        source_selector = {
          winbar = false,
          statusline = false,
        },
      })

      vim.keymap.set("n", "<leader>tq", ":Neotree action=close<CR>")
      vim.keymap.set("n", "<leader>t", ":Neotree<CR>")
    end,
  },
}
