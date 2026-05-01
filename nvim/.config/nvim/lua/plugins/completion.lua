return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
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
