#!/bin/bash
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

    > install
    ./dotfiles.sh -i        

    > test installation (when testing new changes)
    ./dotfiles.sh -ti       

    > install with custom wallpaper
    ./dotfiles.sh -i -w wallpapers/literal-wallpaper.png 

EOF
}




