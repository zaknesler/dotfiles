return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        close_if_last_window = false,
        source_selector = {
          winbar = false,
          statusline = false,
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
      })

      vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<cr>")
      vim.keymap.set("n", "<leader>tq", "<cmd>Neotree close<cr>")
    end,
  }
}
