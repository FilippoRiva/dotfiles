-----------------
---- WINDOWS ----
-----------------

-- Ignore maximize requests from all apps.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name = "zen_workspace",
    match = {
        initial_class = "zen"
    },
    workspace = 1
})

hl.window_rule({
    name = "codium_workspace",
    match = {
        initial_class = "codium"
    },
    workspace = 2
})

hl.window_rule({
    name = "kitty_workspace",
    match = {
        initial_class = "kitty"
    },
    workspace = 3
})