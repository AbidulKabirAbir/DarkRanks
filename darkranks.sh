#!/bin/bash

# Color codes array for banner
colors=(
  '\033[1;31m' # Red
  '\033[1;32m' # Green
  '\033[1;33m' # Yellow
  '\033[1;34m' # Blue
  '\033[1;35m' # Magenta
  '\033[1;36m' # Cyan
)

NC='\033[0m'  # No Color

# Pick a random color for banner on each run
color=${colors[$RANDOM % ${#colors[@]}]}

display_banner() {
    clear
    echo -e "${color}"
    cat << "EOF"
 /$$$$$$$                      /$$       /$$$$$$$                      /$$                
| $$__  $$                    | $$      | $$__  $$                    | $$                
| $$  \ $$  /$$$$$$   /$$$$$$ | $$   /$$| $$  \ $$  /$$$$$$  /$$$$$$$ | $$   /$$  /$$$$$$$
| $$  | $$ |____  $$ /$$__  $$| $$  /$$/| $$$$$$$/ |____  $$| $$__  $$| $$  /$$/ /$$_____/
| $$  | $$  /$$$$$$$| $$  \__/| $$$$$$/ | $$__  $$  /$$$$$$$| $$  \ $$| $$$$$$/ |  $$$$$$ 
| $$  | $$ /$$__  $$| $$      | $$_  $$ | $$  \ $$ /$$__  $$| $$  | $$| $$_  $$  \____  $$
| $$$$$$$/|  $$$$$$$| $$      | $$ \  $$| $$  | $$|  $$$$$$$| $$  | $$| $$ \  $$ /$$$$$$$/
|_______/  \_______/|__/      |__/  \__/|__/  |__/ \_______/|__/  |__/|__/  \__/|_______/ 
EOF
    echo -e "${NC}"
}

read_input() {
    printf "%b\n" "${color}Enter your text (Ctrl+D to finish):${NC}"
    INPUT=$(cat)
    INPUT="${INPUT%"${INPUT##*[![:space:]]}"}"
    if [[ -z "$INPUT" ]]; then
        printf "%b\n" "${color}[!] No input provided.${NC}" >&2
        return 1
    fi
}

# Dummy processing function
process_input() {
    echo "Processed: $INPUT"
}

# Main flow
display_banner
read_input && process_input
