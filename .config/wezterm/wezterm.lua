local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Tomorrow Night Eighties"
config.font = wezterm.font_with_fallback({
  "Monaco",
  "Noto Sans Mono CJK JP",
  "Noto Color Emoji",
  "Symbols Nerd Font Mono"
})
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20

--[[
~/.config.local/wezterm/wezterm.luaに以下のように書くことで設定を上書きできる

return function(config)
  -- (configを上書きする)
  return config
end
]]
local local_config_path = os.getenv("HOME") .. "/.config.local/wezterm/wezterm.lua"
local local_config, ok = loadfile(local_config_path)
if local_config ~= nil then
  config = local_config()(config)

  -- ローカルの設定が変更されたら自動で再読み込みする
  wezterm.add_to_config_reload_watch_list(local_config_path)
end

return config
