PYWAL_DIR="$HOME/.cache/wal"

### Wallpaper Management
propagate_wallpaper() {
    print "Propagating the selected wallpaper"
    cp -f "$WALLPAPER" './themes/sddm/where_is_my_sddm_theme/wallpaper.png'
    mkdir -p "$HOME/Images/wallpapers"
    cp -f "$WALLPAPER" "$HOME/Images/wallpapers/wallpaper.png"
}

propagate_theme() {
    print "Running wal"
    wal -i "$WALLPAPER"    

    for file in "$HOME/.cache/wal"/custom__*; do
            [[ -f "$file" ]] || continue

        custom__app__theme__name="${file##*/}"

        app__theme__name="${custom__app__theme__name#custom__}"
        app="${app__theme__name%%__*}"

        theme__name="${app__theme__name#*__}"
        theme="${theme__name%%__*}"
        name="${theme__name##*__}"

        mkdir -p "./themes/$app/$theme"
        cp "$file" "./themes/$app/$theme/$name"
        print "Updating $app $theme theme form template $name"
    done
}


### Themes
sync_theme() {
    local app=$1
    local theme=$2
    print "Syncing $app theme : $theme"
    sudo rm -rf "usr/share/$app/themes/$theme"
    sudo cp -r "$THEMES_DIR/$app/$theme" "/usr/share/$app/themes/"
}

sync_theme_folder(){
    local app_name=$1
    for theme in "$THEMES_DIR"/"$app_name"/*/; do
        local theme_name=$(basename "$theme")
        sync_theme "$app_name" "$theme_name"
    done
}
 
sync_themes(){
    print_divider "Theme syncing"
    propagate_wallpaper
    propagate_theme
    
    if [[ -n "$USER_MODE" ]]; then
        return 1
    fi

    for app in "$THEMES_DIR"/*/; do
        app_name=$(basename "$app")
        sync_theme_folder $app_name
    done
} 

