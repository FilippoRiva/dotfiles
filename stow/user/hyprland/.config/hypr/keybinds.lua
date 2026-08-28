require("programs")

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Windows control
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close()) -- close
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" })) -- floating
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" })) -- fullscreen

-- Language Switch
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- Programs startup
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(PROGRAMS.terminal))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(PROGRAMS.fileManager))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(PROGRAMS.menu))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(PROGRAMS.browser))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(PROGRAMS.musicPlayer))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(PROGRAMS.screenCapture))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))

-- Move window relatively to it's current position with mainMod + SHIFT + hjkl
hl.bind(mainMod .. "+ SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. "+ SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. "+ SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. "+ SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i , follow=false }))
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Quickshell bindings
hl.bind(mainMod .. "+ Z", hl.dsp.global("quickshell:toggleNotch"))