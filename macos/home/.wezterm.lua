-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.6

config.font = wezterm.font(
    'CaskaydiaCove Nerd Font', { stretch = 'Expanded', weight = 'Bold' }
  )

-- config.color_scheme = 'iTerm2 Default'
-- config.color_scheme = 'Ibm 3270 (High Contrast) (Gogh)'
-- config.color_scheme = 'Wez'
-- config.color_scheme = 'Vibrant Ink (Gogh)'
-- config.color_scheme = 'tokyonight'
-- config.color_scheme = 'Tangoesque (terminal.sexy)'
-- config.macos_window_background_blur = 20

-- and finally, return the configuration to wezterm
return config
