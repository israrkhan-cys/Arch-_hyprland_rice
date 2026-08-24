-- This is a basic Hyprland configuration (converted from hyprland.conf)
-- Save as ~/.config/hypr/hyprland.lua
-- Targets the Lua config system introduced in Hyprland 0.55+
-- https://wiki.hypr.land/Configuring/Start/

----------------------
---- MONITOR ----
----------------------
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-------------------------------
---- GENERAL & DECORATION ----
-------------------------------
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        col = {
            active_border = { colors = { "rgba(7aa2f7ee)", "rgba(bb9af7ee)" }, angle = 45 },
            inactive_border = "rgba(41486866)",
        },
    },

    decoration = {
        -- Rounded corners
        rounding = 10,

        -- CORRECT blur syntax:
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
    },
})

----------------------
---- ANIMATIONS ----
----------------------
hl.config({
    animations = {
        enabled = true,
    },
})

-- Simple but effective curves
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })

hl.window_rule({ match = { class = "^(kitty)$" }, animation = "popin" })
hl.window_rule({ match = { class = "^(firefox)$" }, animation = "slide" })

-- ======== Window Rules ========
-- Named rule syntax
hl.window_rule({
    name = "global-opacity",
    match = { class = ".*" },
    opacity = "0.90",
})

-- Make fullscreen windows 100% opaque
-- hl.window_rule({ match = { fullscreen = true }, opacity = "1.0" })

-- When Chrome/Firefox windows have YouTube/Netflix in title
hl.window_rule({
    match = { title = ".*(YouTube|Netflix|Prime Video|Disney\\+|Twitch|VLC).*" },
    opacity = "1.0 override",
})

-- Specific video players are always opaque
hl.window_rule({
    match = { class = "^(mpv|vlc|celluloid|plexmediaplayer)$" },
    opacity = "1.0 override",
})

hl.window_rule({
    name = "browser-opacity",
    match = { class = "^(firefox|google-chrome-stable)$" },
    opacity = "0.90",
})

hl.window_rule({
    name = "dolphin-opacity",
    match = { class = "^(dolphin)$" },
    opacity = "0.92",
})

hl.window_rule({
    name = "kitty-opacity",
    match = { class = "^(kitty)$" },
    opacity = "0.90",
})

hl.window_rule({
    name = "spotify-opacity",
    match = { class = "^(spotify)$" },
    opacity = "0.92",
})

-- Floating windows
hl.window_rule({
    name = "pavucontrol-float",
    match = { class = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name = "blueman-float",
    match = { class = "^(blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name = "swaync-float",
    match = { class = "^(swaync)$" },
    float = true,
})

-- Floating window styling
hl.window_rule({
    name = "floating-rounding",
    match = { float = true },
    rounding = 15,
})

hl.window_rule({
    name = "floating-opacity",
    match = { float = true },
    opacity = "0.95",
})

-- Specific app enhancements
hl.window_rule({
    name = "browser-rounding",
    match = { class = "^(firefox|google-chrome-stable)$" },
    rounding = 15,
})

-- Dolphin
hl.window_rule({
    name = "dolphin-float",
    match = { class = "^(dolphin)$" },
    float = true,
})

hl.window_rule({
    name = "dolphin-size",
    match = { class = "^(dolphin)$" },
    size = "1000x600",
})

hl.window_rule({
    name = "dolphin-center",
    match = { class = "^(dolphin)$" },
    center = true,
})

-- Kitty terminal
-- NOTE: this duplicates/overrides "kitty-opacity" above (0.90 vs 0.70) exactly
-- as the original .conf did — kept as-is, but you may want to reconcile the two.
hl.window_rule({
    name = "kitty-specific-opacity",
    match = { class = "^(kitty)$" },
    opacity = "0.70",
})

-- Rofi
hl.window_rule({
    name = "rofi-opacity",
    match = { class = "^(rofi)$" },
    opacity = "0.98",
})

hl.window_rule({
    name = "rofi-rounding",
    match = { class = "^(rofi)$" },
    rounding = 20,
})

-- Spotify
hl.window_rule({
    name = "spotify-noborder",
    match = { class = "^(spotify)$" },
    decorate = false,
})

----------------------
---- AUTOSTART ----
----------------------
-- exec-once is expressed as commands run on the "hyprland.start" event
hl.on("hyprland.start", function()
    hl.exec_cmd("swaync")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swww-daemon")
    -- hl.exec_cmd("~/.scripts/wallpaper-daemon.sh")
    hl.exec_cmd("snixembed")
    hl.exec_cmd("waybar")
end)

----------------------
---- KEYBINDINGS ----
----------------------
-- Keybindings - using SUPER (Windows key)
local mainMod = "SUPER"
local menu = "rofi -show drun"

-- Applications ===============================================
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + z", hl.dsp.exec_cmd("evince"))
hl.bind(mainMod .. " + n", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mainMod .. " + v", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("spotify"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("wlogout --protocol layer-shell"))

-- FOR FLOATING WINDOWS =========================================
-- Toggle floating window
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
-- Move floating window
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
-- Resize floating window
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0 }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0 }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20 }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20 }))
-- Center floating window
hl.bind(mainMod .. " + C", hl.dsp.window.center())
-- NOTE: "workspaceopt allfloat" (SUPER+SHIFT+F in the original) has no confirmed
-- 1:1 function in the current hl.dsp API — it isn't in the documented dispatcher
-- table. Verify with `hyprctl repl` on your install before wiring this bind back up.
-- hl.bind(mainMod .. " + SHIFT + F", <workspaceopt allfloat equivalent>)

-- Screenshot ==================================================
-- Screenshot a window
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
-- Screenshot a monitor
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
-- Screenshot a region
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Function keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"))

-- System
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
