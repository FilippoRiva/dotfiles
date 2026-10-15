-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("PATH", "/home/rhiphi/.local/bin:/home/rhiphi/go/bin:/home/rhiphi/.pi/agent/bin:/home/rhiphi/.npm-global/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- nvidia env (suggested by hyprland https://wiki.hypr.land/Nvidia/)
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")