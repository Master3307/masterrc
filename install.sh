#!/usr/bin/env bash
set -euo pipefail

BASH_CUSTOM_URL="https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/.bash_custom"
PROFILE_URL="https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/profile.sh"

TARGET_FILE="$HOME/.bash_custom"
MASTERRC_DIR="$HOME/.masterrc"
PROFILE_FILE="$MASTERRC_DIR/profile.sh"

BASHRC_FILE="$HOME/.bashrc"
SOURCE_LINE='[ -f "$HOME/.bash_custom" ] && source "$HOME/.bash_custom"'

# Colors
# Reset
R='\e[0m'

# Regular colors
BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'

# Bold colors
B_BLACK='\e[1;30m'
B_RED='\e[1;31m'
B_GREEN='\e[1;32m'
B_YELLOW='\e[1;33m'
B_BLUE='\e[1;34m'
B_PURPLE='\e[1;35m'
B_CYAN='\e[1;36m'
B_WHITE='\e[1;37m'

# Underlined
U_BLACK='\e[4;30m'
U_RED='\e[4;31m'
U_GREEN='\e[4;32m'
U_YELLOW='\e[4;33m'
U_BLUE='\e[4;34m'
U_PURPLE='\e[4;35m'
U_CYAN='\e[4;36m'
U_WHITE='\e[4;37m'

# Background colors
BG_BLACK='\e[40m'
BG_RED='\e[41m'
BG_GREEN='\e[42m'
BG_YELLOW='\e[43m'
BG_BLUE='\e[44m'
BG_PURPLE='\e[45m'
BG_CYAN='\e[46m'
BG_WHITE='\e[47m'
BG_GREY='\e[100m'   # bright black / grey

# High-intensity (bright) foregrounds
I_BLACK='\e[0;90m'
I_RED='\e[0;91m'
I_GREEN='\e[0;92m'
I_YELLOW='\e[0;93m'
I_BLUE='\e[0;94m'
I_PURPLE='\e[0;95m'
I_CYAN='\e[0;96m'
I_WHITE='\e[0;97m'

# High-intensity backgrounds
BG_I_BLACK='\e[0;100m'
BG_I_RED='\e[0;101m'
BG_I_GREEN='\e[0;102m'
BG_I_YELLOW='\e[0;103m'
BG_I_BLUE='\e[0;104m'
BG_I_PURPLE='\e[0;105m'
BG_I_CYAN='\e[0;106m'
BG_I_WHITE='\e[0;107m'

# Extra styles
BOLD='\e[1m'
DIM='\e[2m'
ITALIC='\e[3m'        # not supported in all terminals
UNDERLINE='\e[4m'
INVERT='\e[7m'
STRIKE='\e[9m'


echo
echo "              ----------------"
echo "Downloading ~/.bash_custom"
curl -fsSL "$BASH_CUSTOM_URL" -o "$TARGET_FILE"
echo

# NEW: fetch profile.sh into ~/.masterrc/
#echo "              ----------------"
#echo "Downloading profile.sh to ~/.masterrc/profile.sh"
#mkdir -p "$MASTERRC_DIR"
#curl -fsSL "$PROFILE_URL" -o "$PROFILE_FILE"
#chmod +x "$PROFILE_FILE"
#echo

if [ ! -f "$BASHRC_FILE" ]; then
  touch "$BASHRC_FILE"
fi

if ! grep -Fqx "$SOURCE_LINE" "$BASHRC_FILE"; then
  printf '\n%s\n' "$SOURCE_LINE" >> "$BASHRC_FILE"
  echo "Added source line to ~/.bashrc"
  echo
else
  echo "Source line already in ~/.bashrc"
  echo
fi

echo "              ----------------"
printf "${R}Done, Installed/Updated masterrc.\n"
echo
echo "... and have fun with whatever you just installed :3"
echo 'Feel free to try "aptt" in a Terminal. It updates everything.'
printf "\nAlso.. you can run \"${RED}feature${R}\" to install additional features"'!'"\n\nReload your shell with: ${RED}source ~/.bashrc${R}\n\n"

source ~/.bashrc
