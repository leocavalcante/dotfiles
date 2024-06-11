local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'JetBrainsMono Nerd Font Mono'
config.default_prog = { 'ssh', 'PPVM' }

return config
