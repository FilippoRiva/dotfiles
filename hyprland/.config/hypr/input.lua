---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us, it",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        accel_profile = "flat",

        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.2
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Per-device config
hl.device({
    name        = "steelseries-steelseries-prime-wireless",
    sensitivity = -0.3,
})

hl.device({
    name        = "synps/2-synaptics-touchpad",
    sensitivity = 0.2,
})

