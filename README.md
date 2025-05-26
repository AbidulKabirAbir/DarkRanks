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

INPUT=""
MODE=""
ALGORITHM=""

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
        printf "%b\n" "Install it using: ${color}sudo apt install python3${NC}" >&2
        return 1
    fi
}
# 🔐 DarkRanks - Encode & Decode Toolkit (Bash)

DarkRanks is a versatile command-line tool written in pure Bash that allows you to encode and decode text using various algorithms. Designed with a clean, interactive interface and dynamic ASCII art banner, it supports everything from Base64 to Morse code, making it an ideal companion for developers, security enthusiasts, and terminal lovers.

---

## 🎯 Features

- ✅ Encode and decode any text (single word, line, or paragraph)
- ✅ Intuitive menu-driven interface
- ✅ Colorful ASCII banner that changes color on each run
- ✅ Input supports Ctrl+D for multi-line, free-form text entry
- ✅ Cleanly displays encoded or decoded output

### Supported Algorithms

| #   | Algorithm  | Description                    |
|-----|------------|--------------------------------|
| 1   | Base64     | Standard base64 text encoding  |
| 2   | Hex        | Hexadecimal encoding/decoding  |
| 3   | ROT13      | Letter substitution cipher     |
| 4   | Caesar     | Caesar shift cipher            |
| 5   | Morse      | International Morse code       |
| 6   | URL        | URL-safe percent encoding      |
| 7   | Binary     | Binary text representation     |
| 8   | Unicode    | Unicode escape sequences       |
| 9   | Ascii85    | High-density ASCII encoding    |

---

## 🚀 Getting Started

### 🔧 Requirements

Ensure your environment includes the following:

- **Bash** (version 4+)
- **External dependencies**:
  - `base64` – for Base64 encoding
  - `xxd` – for Hex encoding
  - `perl` – used in Unicode and binary conversions
  - `python3` – used in URL and Ascii85 encoding

### 📥 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/darkranks.git
   cd darkranks
   chmod +x darkranks.sh
   ./darkranks.sh
1. Python3 Installation:
   ```bash
   sudo apt-get install python3

## ✍️ Usage Instructions

💡 **Follow the on-screen menu prompts:**

1️⃣ **Select the mode:**  
&nbsp;&nbsp;&nbsp;&nbsp;🔘 `Encode` or `Decode`

2️⃣ **Choose an algorithm:**  
&nbsp;&nbsp;&nbsp;&nbsp;📦 `Base64`, `Morse`, `Binary`, `Hex`, `ROT13`, `Caesar`, `URL`, `Unicode`, or `Ascii85`

3️⃣ **Enter your text:**

   - ⌨️ **Type your input**
   - ⌨️ **Press `Enter` and Press two time `Ctrl + D`** to finalize (signals **EOF**)

---

### 📌 Input Flexibility

You can input:

- 🟢 A **single word**
- 🟡 A **full sentence**
- 🔵 **Multiple lines** or **paragraphs**

After pressing two time `Ctrl + D`, the script will instantly process your input and display the result ✅

---

🧠 **Tip:** The tool trims extra whitespace and handles both short and long inputs effectively.
