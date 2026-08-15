#!/bin/bash
### Globals
DOTFILES_DIR=$(pwd)
STOW_USER_DIR="$DOTFILES_DIR/stow/user"
STOW_SYSTEM_DIR="$DOTFILES_DIR/stow/system"
THEMES_DIR="$DOTFILES_DIR/themes"
WALLPAPERS_DIR="$DOTFILES_DIR/wallpapers"

DEFAULT_WALLPAPER="$WALLPAPERS_DIR"/Doodle_Space_Nord.png

#### Scripts
source scripts/print.sh  || exit 1
source scripts/stow.sh   || exit 1
source scripts/themes.sh || exit 1
source scripts/hooks.sh  || exit 1

### Installation flow
install() {
    stow_install
    sync_themes
    run_hooks
}

### Main
print_banner

if [[ $# -eq 0 ]]; then
    print_usage
    exit 1
fi

while getopts 'ituw:' flag; do
    case "${flag}" in
        i) INSTALL=true         ;;
        t) TEST=true            ;;
        u) USER_MODE=true       ;;
        w) WALLPAPER=$OPTARG    ;;
        \?) print_usage         ;;
    esac
done

if [[ $INSTALL = true ]]; then
    # Set default wallpaper if not specified
    if [[ -z "$WALLPAPER" ]]; then 
        WALLPAPER=$DEFAULT_WALLPAPER
    fi

    # Request sudo if not user mode
    if [[ -z "$USER_MODE" ]]; then 
        if sudo -n true 2>/dev/null; then
            print 'sudo available'
        else 
            sudo -v || exit 1    
        fi
    fi

    install
fi