-- MacOS
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
-- config.window_background_opacity = 0.8
config.font_size = 16.0

-- config.font = wezterm.font(
--     'CaskaydiaCove Nerd Font', { stretch = 'Expanded', weight = 'Regular' }
--   )

-- toggle light/dark scheme with CTRL+l
-- wezterm.on("toggle-dark-mode", function(window,pane)
--   local light_scheme = "Builtin Solarized Light"
--   local dark_scheme = "Builtin Solarized Dark"
--   local overrides = window:get_config_overrides() or {}
--   wezterm.log_info("Current color scheme is: ", overrides.color_scheme)
--   if (overrides.color_scheme == light_scheme)
--   then
--   wezterm.log_info("Setting to Dark Scheme: ", overrides.color_scheme)
--   overrides.color_scheme = dark_scheme
--
--   else
--   wezterm.log_info("Setting to Light ", overrides.color_scheme)
--   overrides.color_scheme = light_scheme
--
--   end
--   window:set_config_overrides(overrides)
-- end)
--
-- config.keys = {
--   {
--     key="l", mods="CTRL", action=wezterm.action{EmitEvent="toggle-dark-mode"},
--   },
-- }

-- config.color_scheme = 'Atelierlakeside (light) (terminal.sexy)'
-- config.color_scheme = 'Atelierlakeside (light) (terminal.sexy)'
-- config.color_scheme = 'iTerm2 Default'
-- config.color_scheme = 'Ibm 3270 (High Contrast) (Gogh)'
-- config.color_scheme = 'Wez'
-- config.color_scheme = 'Vibrant Ink (Gogh)'
-- config.color_scheme = 'tokyonight'
-- config.color_scheme = 'Tangoesque (terminal.sexy)'
-- config.macos_window_background_blur = 20
-- config.color_scheme = 'Windows 95 Light (base16)'

-- and finally, return the configuration to wezterm
return config
