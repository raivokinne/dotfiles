-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "Batman"

-- Set background to same color as neovim
config.colors = {}

config.font = wezterm.font_with_fallback({
	"CPMono_v07",
	"nonicons",
	italic = false,
})

config.cell_width = 1
config.line_height = 0.9

config.term = "alacritty"

-- default is true, has more "native" look
config.use_fancy_tab_bar = false
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = "0.5cell",
	bottom = "0cell",
}

-- I don't like putting anything at the ege if I can help it.
config.enable_scroll_bar = false

config.enable_tab_bar = true
config.freetype_load_target = "HorizontalLcd"

-- config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config
