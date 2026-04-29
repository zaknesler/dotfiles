use ../colors/theme.nu *

export def main [] {
  let theme = (palette)

  return {
    # Primitives
    binary: $theme.number
    block: $theme.type
    bool: {|| if $in { $theme.string } else { $theme.primary } }
    cell-path: $theme.metadata
    closure: $theme.accent
    custom: $theme.fg
    duration: $theme.number
    float: $theme.number
    glob: $theme.link
    int: $theme.number
    list: $theme.type
    nothing: $theme.primary
    range: $theme.number
    record: $theme.type
    string: $theme.string

    datetime: {|| (date now) - $in |
      if $in < 1hr {
        { fg: $theme.primary attr: 'b' }
      } else if $in < 6hr {
        $theme.primary
      } else if $in < 1day {
        $theme.accent
      } else if $in < 3day {
        $theme.number
      } else if $in < 1wk {
        { fg: $theme.string attr: 'b' }
      } else if $in < 6wk {
        $theme.link
      } else if $in < 52wk {
        $theme.type
      } else { $theme.fg_faint }
    }

    filesize: {|e|
      if $e == 0b {
        $theme.fg_faint
      } else if $e < 1mb {
        $theme.string
      } else if $e < 1gb {
        $theme.number
      } else if $e < 100gb {
        $theme.accent
      } else {
        { fg: $theme.primary attr: 'b' }
      }
    }

    # Callables
    shape_internalcall: $theme.accent
    shape_external: $theme.accent
    shape_external_resolved: $theme.accent
    shape_externalarg: $theme.fg
    shape_closure: { fg: $theme.accent attr: 'i' }

    # Keywords / control flow
    shape_keyword: $theme.keyword
    shape_pipe: $theme.keyword
    shape_redirection: { fg: $theme.keyword attr: 'b' }
    shape_and: { fg: $theme.keyword attr: 'b' }
    shape_or: { fg: $theme.keyword attr: 'b' }
    shape_match_pattern: $theme.keyword

    # Operators
    shape_operator: $theme.fg_muted

    # Strings
    shape_string: $theme.string
    shape_string_interpolation: { fg: $theme.link attr: 'b' }
    shape_raw_string: $theme.string_alt

    # Numbers / constants
    shape_int: $theme.number
    shape_float: $theme.number
    shape_range: $theme.number
    shape_binary: $theme.number
    shape_datetime: $theme.number

    # Booleans / nothing
    shape_bool: $theme.primary
    shape_nothing: { fg: $theme.primary attr: 'i' }

    # Filesystem
    shape_filepath: $theme.link
    shape_directory: { fg: $theme.link attr: 'b' }
    shape_glob_interpolation: { fg: $theme.link attr: 'b' }
    shape_globpattern: $theme.link

    # Variables
    shape_variable: $theme.fg
    shape_vardecl: { fg: $theme.fg attr: 'u' }

    # Flags
    shape_flag: { fg: $theme.parameter attr: 'i' }

    # Structural types
    shape_block: { fg: $theme.type attr: 'b' }
    shape_record: $theme.type
    shape_list: $theme.type
    shape_table: { fg: $theme.type attr: 'b' }
    shape_signature: { fg: $theme.type attr: 'i' }

    # Literals
    shape_literal: $theme.number
    shape_custom: { attr: 'b' }

    # Errors
    shape_garbage: { fg: $theme.fg bg: $theme.error_bg attr: 'b' }
    shape_matching_brackets: { attr: 'u' }

    # UI chrome
    foreground: $theme.fg
    background: $theme.bg
    cursor: $theme.primary

    header: { fg: $theme.primary attr: 'b' }
    row_index: { fg: $theme.metadata attr: 'b' }
    separator: $theme.border
    empty: $theme.fg_faint
    hints: $theme.fg_faint
    search_result: { fg: $theme.fg bg: ($theme.primary + '40') }
    leading_trailing_space_bg: { attr: 'n' }
  }
}

export def --env dark [] {
  write_mode "dark"
  $env.config.color_config = (main)
}

export def --env light [] {
  write_mode "light"
  $env.config.color_config = (main)
}

export def --env toggle [] {
  let new = if (current_mode) == "light" { "dark" } else { "light" }
  write_mode $new
  $env.config.color_config = (main)
}
