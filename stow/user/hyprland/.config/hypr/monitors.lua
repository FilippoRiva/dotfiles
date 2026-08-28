----------------------
----   MONITORS   ----
----------------------

hl.monitor({
    output   = "eDP-1", -- thinkpad monitor
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1.25",
})

-- Tower setup

hl.monitor({
    output   = "DP-1", -- Omen on tower
    mode     = "1920x1080@164.92",
    position = "0x0",
    scale    = "auto",
})

hl.monitor({
    output   = "HDMI-A-1", -- Samsung on tower
    mode     = "1920x1080",
    position = "1920x-480",
    transform = 3,
    scale    = "auto",
})
