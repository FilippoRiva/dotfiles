#!/bin/bash
# Utils
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

# Installation and Uninstall procedures
user_apps=(hyprland vscodium)
system_apps=(grub plymouth)

stow_install() {
    print_divider 'Stow install'
    # Install user apps
    for app in "${user_apps[@]}"; do
    	print "Installing ${app} configs"
    	stow --adopt -v ${app}
    done 

    # Install system apps
    for app in "${system_apps[@]}"; do
    	print "Installing ${app} configs"
    	sudo stow --adopt -v -t / ${app}
    done 
    
    # Workaround to overwrite preexisting config (paired with stow --adopt flag)
    if [[ "$TEST" != true ]]; then
        print "Resetting the repo"
        git reset --hard
    fi
}

stow_uninstall() {
    print_divider 'Stow uninstall'
    # Uninstall user apps
    for app in "${user_apps[@]}"; do
    	print "Removing ${app} configs"
    	stow -D -v ${app}
    done 

    # Uninstall system apps
    for app in "${system_apps[@]}"; do
    	print "Removing ${app} configs"
    	stow -D -v -t / ${app}
    done 
}

generate_grub_config() {
    print_divider 'Grub config generation'

    print "Generating grub config..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    print "Grub config updated"
}

reload_hyprland() {
    print_divider 'Hyprland reload'
    print "Reloading Hyprland"
    hyprctl reload
    print "Hyprland reloaded"
}

generate_uki() {
    sudo mkinitcpio -P
}

uninstall() {
    stow_uninstall
}

install() {
    print "Requesting sudo access..."
    sudo -v || return 1

    stow_install
    
    # System stuff
    generate_grub_config
    generate_uki
    
    # User stuff
    reload_hyprland
}

# Main
print_banner

if [[ $# -eq 0 ]]; then
    print_usage
    exit 1
fi

while getopts 'ui' flag; do
    case "${flag}" in
        u) uninstall    ;;
        i) install      ;;
        t) TEST=true ;;
        \?) print_usage  ;;
    esac
done