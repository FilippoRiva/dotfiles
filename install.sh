#!/bin/bash
# Utils
dec=" >"
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

install_configs() {
    # The apps configured in this dotfiles
    local apps=(hyprland vscodium)
    
    
    # Install dotfiles using stow
    for app in "${apps[@]}"; do
    	print "${app} configs"
    	stow -v ${app}
    	print "${app} installed"
    done 
}

main (){
    print_banner
    install_configs
}

main
