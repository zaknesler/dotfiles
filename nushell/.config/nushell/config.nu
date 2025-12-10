use binds.nu
use menus.nu
use theme.nu

$env.config = {
  show_banner: false
  ls: {
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    always_trash: false
  }
  table: {
    mode: light
    index_mode: always
    show_empty: true
    header_on_separator: false
    padding: { left: 1, right: 1 }
    trim: {
      methodology: truncating
      wrapping_try_keep_words: true
      truncating_suffix: "..."
    }
  }
  error_style: "fancy"
  explore: {
    status_bar_background: { fg: "#1D1F21", bg: "#C4C9C6" }
    command_bar_text: { fg: "#C4C9C6" }
    highlight: { fg: "black", bg: "yellow" }
    status: {
      error: { fg: "white", bg: "red" }
      warn: {}
      info: {}
    }
    table: {
      split_line: { fg: "#404040" }
      selected_cell: { bg: light_blue }
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
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
    use_ls_colors: true
  }
  cursor_shape: {
    emacs: line
    vi_insert: block
    vi_normal: underscore
  }
  color_config: (theme)
  footer_mode: "auto"
  float_precision: 2
  buffer_editor: ""
  use_ansi_coloring: true
  bracketed_paste: true
  edit_mode: vi
  render_right_prompt_on_last_line: false
  use_kitty_protocol: false
  highlight_resolved_externals: false
  plugins: {}
  hooks: {
    pre_prompt: [{ null }]
    pre_execution: [{ null }]
    env_change: {
      PWD: [{|before, after| null }]
    }
    display_output: "if (term size).columns >= 100 { table -e } else { table }"
    command_not_found: { null }
  }
  menus: (menus)
  keybindings: (binds)
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

# FNM
source nu_scripts/modules/fnm/fnm.nu
