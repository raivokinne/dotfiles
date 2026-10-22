hl.monitor({
	output = "eDP-1",
	mode = "2560x1664@60.00000",
	position = "0x0",
	scale = 1.6,
	bitdepth = 10,
	cm = "wide",
})

local terminal = "kitty"
local menu = "walker"

local function autostart(bin, cmd)
	return string.format("command -v %s >/dev/null 2>&1 && %s", bin, cmd or bin)
end

local function autostart_file(path)
	return string.format("[ -x %s ] && %s", path, path)
end

hl.on("hyprland.start", function()
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
	)
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice")

	-- clipboard history
	hl.exec_cmd(autostart("wl-clip-persist", "wl-clip-persist --clipboard regular"))
	hl.exec_cmd(autostart("cliphist", "wl-paste --type text --watch cliphist -max-items=35 store"))
	hl.exec_cmd(autostart("cliphist", "wl-paste --type image --watch cliphist -max-items=10 store"))

	-- desktop services
	hl.exec_cmd(autostart("swaync"))
	hl.exec_cmd(autostart("xfce-polkit", "/usr/lib/xfce-polkit/xfce-polkit"))
	hl.exec_cmd(autostart("nwg-dock", "nwg-dock -p left -d -w 5 -nolauncher -ml 5 -l top -hl bottom -i 38"))
	hl.exec_cmd(autostart("elephant"))
	hl.exec_cmd(autostart("wl-gammarelay-rs"))

	-- wallpaper
	hl.exec_cmd(autostart("hyprpaper"))

	hl.exec_cmd("quickshell -p ~/.config/quickshell/shell.qml")
end)

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

local colors = {
	bg = "000000",
	fg = "F4F4F5",
	comment = "777783",

	gray0 = "0a0a0b",
	gray1 = "121215",
	gray2 = "1b1b20",
	gray3 = "2c2c34",
	gray4 = "43434d",
	gray5 = "5a5a66",
	gray6 = "777783",

	accent = "FFAD66",
	warn = "F1FA8C",
	red = "FF5C70",
	green = "6EFF8A",
	cyan = "45D6FF",
	blue = "82AAFF",
	purple = "C792EA",
	pink = "FF79C6",
}

local function rgba(hex, alpha)
	return string.format("rgba(%s%s)", hex, alpha or "ee")
end

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 1,

		col = {
			active_border = rgba(colors.accent),
			inactive_border = rgba(colors.gray4),
			nogroup_border = rgba(colors.gray4),
			nogroup_border_active = rgba(colors.accent),
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		dim_inactive = false,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.config({
	misc = {
		font_family = "Pragmasevka Nerd Font",
		background_color = rgba(colors.bg),
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
	},
})

hl.config({
	group = {
		col = {
			border_active = rgba(colors.accent),
			border_inactive = rgba(colors.gray4),
			border_locked_active = rgba(colors.warn),
			border_locked_inactive = rgba(colors.gray3),
		},

		groupbar = {
			font_family = "Pragmasevka Nerd Font",
			font_size = 12,
			height = 22,
			text_color = rgba(colors.bg),
			text_color_inactive = rgba(colors.comment),
			col = {
				active = rgba(colors.accent),
				inactive = rgba(colors.gray1),
				locked_active = rgba(colors.warn),
				locked_inactive = rgba(colors.gray3),
			},
		},
	},
})

hl.config({
	dwindle = {
		preserve_split = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fadeSwitch", enabled = false })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false })

hl.config({
	input = {
		kb_layout = "lv",
		kb_options = "grp:alt_shift_toggle,caps:escape",

		repeat_delay = 200,
		repeat_rate = 60,

		follow_mouse = 1,

		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.device({
	name = "Apple MTP multi-touch",
	disable_while_typing = false, -- dwt disabled
	tap_to_click = false, -- tap disabled
	natural_scroll = true, -- natural_scroll enabled
	middle_button_emulation = false, -- middle_emulation disabled
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + d", hl.dsp.exec_cmd(menu))

hl.bind(mainMod .. " + q", hl.dsp.window.kill())
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("$HOME/.config/scripts/screenshot.sh area"))

hl.bind(mainMod .. " + minus", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad" }))

hl.bind(mainMod .. " + f", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hl.dsp.window.cycle_next({ floating = true }))

hl.bind(mainMod .. " + b", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + v", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + e", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + s", hl.dsp.group.toggle())
hl.bind(mainMod .. " + w", hl.dsp.group.toggle())

local directions = { h = "left", j = "down", k = "up", l = "right" }
for key, dir in pairs(directions) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = dir }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

hl.define_submap("resize", function()
	local resize = {
		h = { -10, 0 },
		j = { 0, 10 },
		k = { 0, -10 },
		l = { 10, 0 },
		left = { -10, 0 },
		down = { 0, 10 },
		up = { 0, -10 },
		right = { 10, 0 },
	}

	for key, delta in pairs(resize) do
		hl.bind(key, hl.dsp.window.resize({ x = delta[1], y = delta[2], relative = true }))
	end

	hl.bind("Return", hl.dsp.submap("reset"))
	hl.bind("Escape", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + r", hl.dsp.submap("resize"))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioForward", hl.dsp.exec_cmd("playerctl position +10"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioRewind", hl.dsp.exec_cmd("playerctl position -10"))

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
