local w = require "wezterm"
local c = w.config_builder()

local is_win = w.target_triple:find("windows")

if is_win then
  c.default_prog = { "nu" }
end

c.max_fps = 240
c.initial_cols = 130
c.initial_rows = 35
c.line_height = 1.2
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
c.window_close_confirmation = "NeverPrompt"
c.window_frame = {
  font = w.font("Hack Nerd Font"),
  font_size = is_win and 12 or 14,
  border_left_width = '1px',
  border_right_width = '1px',
  border_bottom_height = '1px',
  border_left_color = 'rgb(255 255 255 / 20%)',
  border_right_color = 'rgb(255 255 255 / 20%)',
  border_bottom_color = 'rgb(255 255 255 / 20%)',
  active_titlebar_bg = 'rgb(0 0 0 / 30%)',
}
c.window_padding = {
  left = 32,
  right = 32,
  top = 32,
  bottom = 32,
}
c.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#333",
      fg_color = "#fff",
    },
    inactive_tab = {
      bg_color = "#000",
      fg_color = "#555",
    },
  }
}

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

c.macos_window_background_blur = 20
c.win32_system_backdrop = "Acrylic"
c.background = {
  {
    source = { Color = "black" },
    opacity = is_win and 0.5 or 0.8,
    width = "100%",
    height = "100%",
  },
  {
    source = { File = w.config_dir .. "/background.png" },
    vertical_align = "Middle",
    opacity = is_win and 0.15 or 0.1,
  }
}

w.on("format-tab-title", function(tab)
  local title = tab.active_pane.title
  local max_title_width = 30

  if #title > max_title_width then
    -- Truncate middle with ellipsis
    local ellipsis = "…"
    local chars_to_show = max_title_width - #ellipsis
    local left_chars = math.floor(chars_to_show / 2)
    local right_chars = chars_to_show - left_chars
    title = title:sub(1, left_chars) .. ellipsis .. title:sub(-right_chars)
  else
    -- Center short titles with padding to reach the max width
    local padding = max_title_width - #title
    local left_pad = math.floor(padding / 2)
    local right_pad = padding - left_pad
    title = string.rep(" ", left_pad) .. title .. string.rep(" ", right_pad)
  end

  return {
    { Text = title },
  }
end)

return c
