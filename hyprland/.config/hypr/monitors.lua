----------------------
----   MONITORS   ----
----------------------

hl.monitor({
    output   = "eDP-1", -- thinkpad monitor
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1.25",
})

hl.monitor({
    output   = "DP-3", -- Omen through docking station
    mode     = "1920x1080@120",
    position = "-1920x0",
    scale    = "auto",
})

hl.monitor({
    output   = "DP-4", -- Samsung through docking station
    mode     = "1920x1080",
    position = "-3000x-500",
    transform = 1,
    scale    = "auto",
})