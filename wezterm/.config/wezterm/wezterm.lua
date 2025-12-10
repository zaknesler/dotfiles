local w = require "wezterm"
local c = w.config_builder()

local is_win = w.target_triple:find("windows")

if is_win then
  c.default_prog = { "nu" }
end

-- Appearance
c.max_fps = 240
c.initial_cols = 115
c.initial_rows = 30
c.line_height = 1.15
c.font = w.font("Hack Nerd Font")
c.font_size = is_win and 11 or 14
c.color_scheme = "Atelier Savanna (base16)"
c.adjust_window_size_when_changing_font_size = false
c.send_composed_key_when_right_alt_is_pressed = false
c.show_new_tab_button_in_tab_bar = false
c.show_tab_index_in_tab_bar = false
c.window_decorations = 'NONE|RESIZE'
c.audible_bell = "Disabled"
c.automatically_reload_config = true
c.window_frame = {
  font = w.font("Hack Nerd Font"),
  font_size = 12,
  border_left_width = '1px',
  border_right_width = '1px',
  border_bottom_height = '1px',
  border_left_color = 'rgb(255 255 255 / 20%)',
  border_right_color = 'rgb(255 255 255 / 20%)',
  border_bottom_color = 'rgb(255 255 255 / 20%)',
}
c.window_padding = {
  left = 32,
  right = 32,
  top = 32,
  bottom = 32,
}
c.window_close_confirmation = "NeverPrompt"
c.tab_max_width = 32

-- Binds
c.keys = {
  {
    key = "w",
    mods = "CMD",
    action = w.action.CloseCurrentPane { confirm = false },
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = w.action.CloseCurrentPane { confirm = false },
  },
}

-- Background
c.macos_window_background_blur = 20
c.win32_system_backdrop = "Acrylic"
c.background = {
  {
    source = { Color = "black" },
    opacity = is_win and 0.5 or 0.7,
    width = "100%",
    height = "100%",
  },
  {
    source = { File = w.config_dir .. "/background.png" },
    vertical_align = "Middle",
    opacity = is_win and 0.15 or 0.15,
  }
}

return c
