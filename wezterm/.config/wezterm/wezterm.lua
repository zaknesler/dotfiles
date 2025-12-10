local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.initial_cols = 115
config.initial_rows = 30
config.font_size = 14
config.line_height = 1.15
config.color_scheme = "Github Dark (Gogh)"
config.font = wezterm.font("Hack Nerd Font")

config.window_decorations = "RESIZE"
config.keys = {
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
}

-- Background
config.macos_window_background_blur = 20
config.win32_system_backdrop = "Acrylic"
config.background = {
  {
    source = { Color = "black" },
    opacity = 0.8,
    width = "100%",
    height = "100%",
  },
  {
    source = { File = wezterm.config_dir .. "/background.png" },
    vertical_align = "Middle",
    opacity = 0.2,
  }
}

return config
