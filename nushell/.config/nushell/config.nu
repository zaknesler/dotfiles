use binds.nu
use menus.nu
use theme.nu
use colors/theme.nu *

let theme = (palette)

$env.config = {
  menus: (menus)
  keybindings: (binds)
  color_config: (theme)

  show_banner: false
  error_style: "fancy"
  footer_mode: "auto"
  float_precision: 2
  buffer_editor: ""
  use_ansi_coloring: true
  bracketed_paste: true
  edit_mode: vi
  render_right_prompt_on_last_line: false
  use_kitty_protocol: false
  highlight_resolved_externals: false

  ls: {
    use_ls_colors: false
    clickable_links: true
  }

  rm: {
    always_trash: false
  }

  table: {
    mode: light
    index_mode: always
    show_empty: true
    header_on_separator: true
    padding: { left: 1, right: 1 }
    trim: {
      methodology: truncating
      wrapping_try_keep_words: true
      truncating_suffix: "..."
    }
  }

  explore: {
    status_bar_background: { fg: $theme.fg, bg: $theme.border }
    command_bar_text: { fg: $theme.fg }
    highlight: { fg: $theme.bg, bg: $theme.number }
    status: {
      error: { fg: $theme.fg, bg: $theme.error }
      warn: { fg: $theme.bg, bg: $theme.number }
      info: { fg: $theme.bg, bg: $theme.link }
    }
    table: {
      split_line: { fg: $theme.border }
      selected_cell: { bg: $theme.primary, fg: $theme.bg }
      selected_row: {}
      selected_column: {}
    }
  }

  history: {
    max_size: 100_000
    sync_on_enter: true
    file_format: "plaintext"
    isolation: false
  }

  completions: {
    use_ls_colors: false
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }

  cursor_shape: {
    emacs: line
    vi_insert: block
    vi_normal: underscore
  }

  plugins: {}
  hooks: {
    display_output: "if (term size).columns >= 100 { table -e } else { table }"
    pre_prompt: [{ null }]
    pre_execution: [{ null }]
    command_not_found: { null }
    env_change: {
      PWD: [{|before, after| null }]
    }
  }
}

# Aliases
source aliases.nu

# Functions
source functions.nu

# Completions
source nu_scripts/custom-completions/cargo/cargo-completions.nu
source nu_scripts/custom-completions/gh/gh-completions.nu
source nu_scripts/custom-completions/git/git-completions.nu
source nu_scripts/custom-completions/npm/npm-completions.nu
source nu_scripts/custom-completions/pnpm/pnpm-completions.nu
source nu_scripts/custom-completions/rustup/rustup-completions.nu

use sync.nu
use branches.nu
