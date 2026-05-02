return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      fuzzy = {
        implementation = vim.fn.has("win32") == 1 and "lua" or "prefer_rust",
      },
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        accept = { auto_brackets = { enabled = true } },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
    },
  },
}
