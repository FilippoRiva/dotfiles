plymouth_hook() {
    print 'Plymouth Hook: rebuild Unified Kernel Image (UKI)...'
    sudo mkinitcpio -P
}

grub_hook() {
    print "Grub Hook: generating grub config..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

hyprland_hook() {
    print "Hyprland Hook: Reloading Hyprland and Hyprpaper"
    hyprctl reload 1>/dev/null
    pkill -x hyprpaper
    hyprpaper 1>/dev/null &
}

run_hooks() {
    print_divider "Post-installation Hooks"
    # System level hooks
    if [[ -z "$USER_MODE"  ]]; then
        grub_hook
        plymouth_hook
    fi

    # User level hooks
    hyprland_hook
}