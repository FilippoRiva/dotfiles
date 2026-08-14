#!/bin/bash
#### Print Utilities
print() {
    local content=$1
    echo " > ${content}"
}

print_banner() {
    cat <<'EOF'

             _____  _    _ _____ _____  _    _ _____         
            |  __ \| |  | |_   _|  __ \| |  | |_   _|        
            | |__) | |__| | | | | |__) | |__| | | |          
            |  _  /|  __  | | | |  ___/|  __  | | |          
            | | \ \| |  | |_| |_| |    | |  | |_| |_         
      _____ |_|__\_\_|__|_|_____|_|____|_|  |_|_____|  _____ 
     |  __ \ / __ \__   __|  ____|_   _| |    |  ____|/ ____|
     | |  | | |  | | | |  | |__    | | | |    | |__  | (___  
     | |  | | |  | | | |  |  __|   | | | |    |  __|  \___ \ 
     | |__| | |__| | | |  | |     _| |_| |____| |____ ____) |
     |_____/ \____/  |_|  |_|    |_____|______|______|_____/ 
                                                             
            ~ configure once, deploy everywhere ~
    
EOF
}

print_divider() {
    local text="$1"
    local width=60
    local padding=$(( (width - ${#text} - 2) / 2 ))

    printf '\n    %*s %s %*s\n\n' \
        "$padding" '' "$text" "$padding" '' |
        tr ' ' '-'
}

print_usage() {
    cat <<'EOF'
    >> Usage :
    sh dotfiles.sh -i     -- installs
    sh dotfiles.sh -u     -- uninstalls
EOF
}







#### Installation procedures
user_apps=(hyprland vscodium)
system_apps=(grub plymouth)

stow_install() {
    print_divider 'Stow install'
    # Install user apps
    echo "User-level applications:"
    for app in "${user_apps[@]}"; do
    	print "Installing ${app} configs"
    	stow --adopt -v ${app}
    done 

    # Install system apps
    echo "System-level applications:"
    for app in "${system_apps[@]}"; do
    	print "Installing ${app} configs"
    	sudo stow --adopt -v -t / ${app}
    done 
    
    # Workaround to overwrite preexisting config (paired with stow --adopt flag)
    if [[ "$TEST" != true ]]; then
        print "Deleting old configs"
        git reset --hard
    fi
}

# Generates grub configs
grub_sync() {
    print_divider 'Grub sync'

    print "Generating grub config:"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

# Syncs themes and builds a new UKI
plymouth_sync() {
    print_divider 'Plymouth sync'
    for theme in plymouth_themes/usr/share/plymouth/themes/*/; do
        print "Syncing theme : $(basename $theme)"
        sudo rm -rf "/usr/share/plymouth/themes/$(basename "$theme")"
        sudo cp -r "$theme" /usr/share/plymouth/themes/
    done

    print 'Rebuilding UKI:'
    sudo mkinitcpio -P
}

hyprland_sync() {
    print_divider 'Hyprland reload'
    print "Reloading Hyprland"
    hyprctl reload
}


install() {
    print "Requesting sudo access:"
    sudo -v || return 1

    stow_install
    
    # System stuff
    grub_sync
    plymouth_sync
    
    # User stuff
    hyprland_sync
}

# Main
print_banner

if [[ $# -eq 0 ]]; then
    print_usage
    exit 1
fi

while getopts 'uit' flag; do
    case "${flag}" in
        u) uninstall    ;;
        i) INSTALL=true      ;;
        t) TEST=true ;;
        \?) print_usage  ;;
    esac
done

if [[ $INSTALL = true ]]; then
    install
fi