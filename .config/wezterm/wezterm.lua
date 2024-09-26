-- https://wezfurlong.org/wezterm/config/lua/config/index.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Tomorrow Night Eighties"
config.font = wezterm.font_with_fallback({
  "Monaco",
  "Noto Sans Mono CJK JP",
  "Noto Color Emoji",
  "Symbols Nerd Font Mono"
})

config.command_palette_rows = 14
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.8
config.window_decorations = "TITLE | RESIZE | MACOS_FORCE_ENABLE_SHADOW"
config.macos_window_background_blur = 20

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.keys = {
  { key = "Enter", mods = "SUPER", action = wezterm.action.ToggleFullScreen },
  { key = "P",     mods = "SUPER", action = wezterm.action.ActivateCommandPalette }
}

--[[
~/.config.local/wezterm/wezterm.luaに以下のように書くことで設定を上書きできる

return function(config)
  -- (configを変更する)
  return config
end
]]
local local_config_path = wezterm.home_dir .. "/.config.local/wezterm/wezterm.lua"
local local_config, ok = loadfile(local_config_path)
if local_config ~= nil then
  config = local_config()(config)

  -- ローカルの設定が変更されたら自動で再読み込みする
  wezterm.add_to_config_reload_watch_list(local_config_path)
end

return config
