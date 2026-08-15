### Stow 
user_stow_install() {
    print_divider 'User GNU stow'
    cd $STOW_USER_DIR
    for app in *; do 
    	print "Installing $app configs"
    	stow --adopt -v -t $HOME $app
    done
    cd $DOTFILES_DIR
}

system_stow_install() {
    if [[ -n "$USER_MODE" ]]; then
        return 1
    fi

    print_divider 'System GNU stow'

    cd $STOW_SYSTEM_DIR
    for app in *; do
    	print "Installing ${app} configs"
    	sudo stow --adopt -v -t / ${app}
    done 
    cd $DOTFILES_DIR
}

stow_install() {
    user_stow_install
    system_stow_install
    
    # Workaround to overwrite preexisting config (paired with stow --adopt flag)
    if [[ "$TEST" != true ]]; then
        print "Deleting old configs"
        git reset --hard
    fi
}