use orange.nu *

const theme = {
  light: $orange_light,
  dark: $orange_dark,
}

def state_file [] {
  $nu.default-config-dir | path join ".mode"
}

export def current_mode [] {
  try { open (state_file) | str trim } catch { "dark" }
}

export def write_mode [mode: string] {
  $mode | save -f (state_file)
}

export def palette [] {
  if (current_mode) == "light" {
    $theme.light
  } else {
    $theme.dark
  }
}
