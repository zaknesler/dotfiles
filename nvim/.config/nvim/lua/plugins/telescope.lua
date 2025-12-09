return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local builtin = require('telescope.builtin')

      -- Find files in cwd
      vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

      -- Find git-tracked files
      vim.keymap.set('n', '<C-p>', builtin.git_files, {})

      -- Search for string in cwd
      vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end)

      -- Lists available help tags
      vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})
    end,
  },
}
