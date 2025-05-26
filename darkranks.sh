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

check_python() {
    if ! command -v python3 >/dev/null; then
        printf "%b\n" "${color}[!] Python3 is required for URL encode/decode.${NC}" >&2
        printf "%b\n" "${color}Install it using: sudo apt install python3${NC}" >&2
        return 1
    fi
}

read_input() {
    printf "%b\n" "${color}Enter your text (Ctrl+D to finish):${NC}"
    INPUT=$(cat)  # Read all input until Ctrl+D
    INPUT="${INPUT%"${INPUT##*[![:space:]]}"}"  # Trim trailing whitespace/newlines
    if [[ -z "$INPUT" ]]; then
        # Accept empty input, add blank line before result
        INPUT=""
        printf "\n"
    fi
}

process_input() {
    local result shift upper lower UPPER LOWER
    case "$ALGORITHM" in
        base64)
            if [[ "$MODE" == "encode" ]]; then
                result=$(printf "%s" "$INPUT" | base64)
            else
                result=$(printf "%s" "$INPUT" | base64 --decode 2>/dev/null)
                [[ $? -ne 0 ]] && { printf "%b\n" "${color}[!] Invalid base64 input.${NC}" >&2; return 1; }
            fi
            ;;
        hex)
            if [[ "$MODE" == "encode" ]]; then
                result=$(printf "%s" "$INPUT" | xxd -p)
            else
                result=$(printf "%s" "$INPUT" | xxd -r -p 2>/dev/null)
                [[ $? -ne 0 || -z "$result" ]] && { printf "%b\n" "${color}[!] Invalid hex input.${NC}" >&2; return 1; }
            fi
            ;;
        rot13)
            result=$(printf "%s" "$INPUT" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
            ;;
        caesar)
            printf "%b\n" "${color}Enter shift value (1-25):${NC}"
            read -r shift
            if [[ ! "$shift" =~ ^[1-9]$|^1[0-9]$|^2[0-5]$ ]]; then
                printf "%b\n" "${color}[!] Invalid shift value.${NC}" >&2
                return 1
            fi
            upper=$(printf "%s" {A..Z} | tr -d ' ')
            lower=$(printf "%s" {a..z} | tr -d ' ')
            if [[ "$MODE" == "encode" ]]; then
                UPPER="${upper:$shift}${upper:0:$shift}"
                LOWER="${lower:$shift}${lower:0:$shift}"
                result=$(printf "%s" "$INPUT" | tr "$upper$lower" "$UPPER$LOWER")
            else
                UPPER="${upper:26-$shift}${upper:0:26-$shift}"
                LOWER="${lower:26-$shift}${lower:0:26-$shift}"
                result=$(printf "%s" "$INPUT" | tr "$upper$lower" "$UPPER$LOWER")
            fi
            ;;
        morse)
            morse() {
                declare -A MORSE_ENCODE=(
                    [a]=".-" [b]="-..." [c]="-.-." [d]="-.." [e]="." [f]="..-."
                    [g]="--." [h]="...." [i]=".." [j]=".---" [k]="-.-" [l]=".-.."
                    [m]="--" [n]="-." [o]="---" [p]=".--." [q]="--.-" [r]=".-."
                    [s]="..." [t]="-" [u]="..-" [v]="...-" [w]=".--" [x]="-..-"
                    [y]="-.--" [z]="--.."
                    [1]=".----" [2]="..---" [3]="...--" [4]="....-" [5]="....."
                    [6]="-...." [7]="--..." [8]="---.." [9]="----." [0]="-----"
                    ["."]=".-.-.-" [","]="--..--" ["?"]="..--.." ["!"]="-.-.--" [" "]= "/"
                )
                declare -A MORSE_DECODE
                for k in "${!MORSE_ENCODE[@]}"; do
                    MORSE_DECODE[${MORSE_ENCODE[$k]}]=$k
                done

                if [[ "$MODE" == "encode" ]]; then
                    local input_lower=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
                    local result=""
                    for (( i=0; i<${#input_lower}; i++ )); do
                        c="${input_lower:i:1}"
                        code="${MORSE_ENCODE[$c]}"
                        [[ -z "$code" ]] && code="?"  # fallback for unknown chars
                        result+="$code "
                    done
                    echo "$result"
                else
                    local result=""
                    for code in $INPUT; do
                        char="${MORSE_DECODE[$code]}"
                        [[ -z "$char" ]] && char="?"  # fallback for unknown codes
                        result+="$char"
                    done
                    echo "$result"
                fi
            }
            result=$(morse)
            ;;
        url)
            check_python || return 1
            if [[ "$MODE" == "encode" ]]; then
                result=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$INPUT'''))")
            else
                result=$(python3 -c "import urllib.parse; print(urllib.parse.unquote('''$INPUT'''))")
            fi
            ;;
        binary)
            if [[ "$MODE" == "encode" ]]; then
                result=$(printf "%s" "$INPUT" | perl -lpe '$_=unpack"B*"')
            else
                result=$(printf "%s" "$INPUT" | perl -lpe '$_=pack"B*",$_')
            fi
            ;;
        unicode)
            if [[ "$MODE" == "encode" ]]; then
                result=$(printf "%s" "$INPUT" | perl -CS -Mutf8 -MEncode -ne 'print join(" ", map { sprintf("\\u%04x", ord($_)) } split //)')
            else
                result=$(printf "%s" "$INPUT" | perl -pe 's/\\u([0-9a-fA-F]{4})/chr(hex($1))/ge')
            fi
            ;;
        ascii85)
            check_python || return 1
            if [[ "$MODE" == "encode" ]]; then
                result=$(printf "%s" "$INPUT" | python3 -c "import base64,sys; print(base64.a85encode(sys.stdin.buffer.read()).decode())")
            else
                result=$(printf "%s" "$INPUT" | python3 -c "import base64,sys; print(base64.a85decode(sys.stdin.buffer.read()).decode())")
            fi
            ;;
        *)
            printf "%b\n" "${color}[!] Invalid algorithm selected.${NC}" >&2
            return 1
            ;;
    esac
    printf "%b\n%b\n" "${color}Result:${NC}" "$result"
}

main() {
    while true; do
        display_banner
        printf "%b\n" "${color}Choose mode:${NC} 1) Encode  2) Decode  0) Exit"
        read -rp "> " choice
        case "$choice" in
            1) MODE="encode" ;;
            2) MODE="decode" ;;
            0) return ;;
            *) printf "%b\n" "${color}[!] Invalid choice.${NC}" >&2; continue ;;
        esac

        printf "%b\n" "${color}Choose algorithm:${NC}"
        printf "%b\n" "${color}1) Base64\n2) Hex\n3) ROT13\n4) Caesar\n5) Morse\n6) URL\n7) Binary\n8) Unicode\n9) Ascii85${NC}"
        read -rp "> " algo_choice
        case "$algo_choice" in
            1) ALGORITHM="base64" ;;
            2) ALGORITHM="hex" ;;
            3) ALGORITHM="rot13" ;;
            4) ALGORITHM="caesar" ;;
            5) ALGORITHM="morse" ;;
            6) ALGORITHM="url" ;;
            7) ALGORITHM="binary" ;;
            8) ALGORITHM="unicode" ;;
            9) ALGORITHM="ascii85" ;;
            *) printf "%b\n" "${color}[!] Invalid algorithm choice.${NC}" >&2; continue ;;
        esac

        if ! read_input; then
            printf "%b\n" "${color}[!] Input error, try again.${NC}" >&2
            continue
        fi

        if ! process_input; then
            printf "%b\n" "${color}[!] Processing error, try again.${NC}" >&2
            continue
        fi

        printf "%b\n" "${color}Press Enter to continue...${NC}"
        read -r
    done
}

main
