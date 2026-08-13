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

        sensitivity = 0, 

        touchpad = {
            natural_scroll = true,
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
    sensitivity = 0,
})

