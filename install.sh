#!/usr/bin/env bash
set -euo pipefail


BASH_CUSTOM_URL="https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/.bash_custom"


TARGET_FILE="$HOME/.bash_custom"
MASTERRC_DIR="$HOME/.masterrc"


BASHRC_FILE="$HOME/.bashrc"
SOURCE_LINE='[ -f "$HOME/.bash_custom" ] && source "$HOME/.bash_custom"'


# Colors #
##########
# Reset
R='\e[0m'
# Regular colors
BLACK='\e[30m';  RED='\e[31m';   GREEN='\e[32m';    YELLOW='\e[33m'
BLUE='\e[34m';   PURPLE='\e[35m'; CYAN='\e[36m';    WHITE='\e[37m'
# Bold colors
B_BLACK='\e[1;30m'; B_RED='\e[1;31m';  B_GREEN='\e[1;32m';  B_YELLOW='\e[1;33m'
B_BLUE='\e[1;34m';  B_PURPLE='\e[1;35m'; B_CYAN='\e[1;36m'; B_WHITE='\e[1;37m'
# Underlined
U_BLACK='\e[4;30m'; U_RED='\e[4;31m';  U_GREEN='\e[4;32m';  U_YELLOW='\e[4;33m'
U_BLUE='\e[4;34m';  U_PURPLE='\e[4;35m'; U_CYAN='\e[4;36m'; U_WHITE='\e[4;37m'
# Background colors
BG_BLACK='\e[40m'; BG_RED='\e[41m';  BG_GREEN='\e[42m';  BG_YELLOW='\e[43m'
BG_BLUE='\e[44m';  BG_PURPLE='\e[45m'; BG_CYAN='\e[46m'; BG_WHITE='\e[47m'; BG_GREY='\e[100m'   # bright black / grey
# High-intensity (bright) foregrounds
I_BLACK='\e[0;90m'; I_RED='\e[0;91m';  I_GREEN='\e[0;92m';  I_YELLOW='\e[0;93m'
I_BLUE='\e[0;94m';  I_PURPLE='\e[0;95m'; I_CYAN='\e[0;96m'; I_WHITE='\e[0;97m'
# High-intensity backgrounds
BG_I_BLACK='\e[0;100m'; BG_I_RED='\e[0;101m'; BG_I_GREEN='\e[0;102m'; BG_I_YELLOW='\e[0;103m'
BG_I_BLUE='\e[0;104m';  BG_I_PURPLE='\e[0;105m'; BG_I_CYAN='\e[0;106m'; BG_I_WHITE='\e[0;107m'
# Extra styles
BOLD='\e[1m'; DIM='\e[2m'; ITALIC='\e[3m'
UNDERLINE='\e[4m'; INVERT='\e[7m'; STRIKE='\e[9m'




if [ "$(id -u)" -eq 0 ] || [ -n "${TERMUX_VERSION:-}" ] || [[ "${PREFIX:-}" == *com.termux* ]]; then
    sudo=""
else
    sudo="sudo"
fi


if [ -n "${TERMUX_VERSION:-}" ] || [[ "${PREFIX:-}" == *com.termux* ]]; then
    nerdfetch_target="${PREFIX:-/data/data/com.termux/files/usr}/bin/nerdfetch"
    nerdfetch_chmod="a+x"
    is_termux_usr="${PREFIX:-/data/data/com.termux/files/usr/}"
else
    nerdfetch_target="/usr/bin/nerdfetch"
    nerdfetch_chmod="u+x"
    is_termux_usr="/usr"
fi


MASTERRC_URL="https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/masterrc.sh"
MASTERRC_TARGET="$is_termux_usr/bin/masterrc"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

status() {
    local state="$1"
    local item="$2"
    local message="$3"

    case "$state" in
        loading) printf "${DIM}[..]${R} ${RED}%s${R} %s\r" "$item" "$message" ;;
        check)   printf "${GREEN}[✓]${R} ${RED}%s${R} %s\n" "$item" "$message" ;;
        update)  printf "${GREEN}[✓]${R} ${RED}%s${R} %s\n" "$item" "$message" ;;
        install) printf "${GREEN}[✓]${R} ${RED}%s${R} %s\n" "$item" "$message" ;;
        info)    printf "${YELLOW}[!]${R} ${RED}%s${R} %s\n" "$item" "$message" ;;
        error)   printf "${RED}[✗]${R} ${RED}%s${R} %s\n" "$item" "$message" ;;
    esac
}

download_and_update() {
    local url="$1"
    local target="$2"
    local label="$3"
    local use_sudo="${4:-false}"
    local temp_file="$TMP_DIR/$(basename "$target")"

    status loading "$label" "Checking for updates..."

    if ! curl -fsSL "$url" -o "$temp_file"; then
        printf '\n'
        status error "$label" "Failed to check for updates."
        exit 1
    fi

    if [ ! -e "$target" ]; then
        if [ "$use_sudo" = true ]; then
            $sudo install -Dm755 "$temp_file" "$target"
        else
            install -Dm644 "$temp_file" "$target"
        fi
        printf '\r'
        status install "$label" "has been installed."
        return
    fi

    if cmp -s "$temp_file" "$target"; then
        printf '\r'
        status check "$label" "is Up to Date."
        return
    fi

    if [ "$use_sudo" = true ]; then
        $sudo install -Dm755 "$temp_file" "$target"
    else
        install -Dm644 "$temp_file" "$target"
    fi

    printf '\r'
    status update "$label" "has been updated."
}


echo
echo "              ----------------"

if [ ! -f "$TARGET_FILE" ]; then
    status info "~/.bash_custom" "Fresh install detected."
fi

download_and_update "$BASH_CUSTOM_URL" "$TARGET_FILE" "~/.bash_custom"


if [ ! -f "$BASHRC_FILE" ]; then
  touch "$BASHRC_FILE"
fi


if ! grep -Fqx "$SOURCE_LINE" "$BASHRC_FILE"; then
  printf '\n%s\n' "$SOURCE_LINE" >> "$BASHRC_FILE"
  status install "~/.bashrc" "Source line has been added."
else
  status check "~/.bashrc" "Source line is Up to Date."
fi


echo
echo "              ----------------"

if [ ! -f "$MASTERRC_TARGET" ]; then
    status info "masterrc" "Fresh install detected."
fi

download_and_update "$MASTERRC_URL" "$MASTERRC_TARGET" "masterrc" true


echo
echo "              ----------------"
printf "${R}Done, checked masterrc for updates.\n"
printf "... and have fun with whatever you just installed :3\n\n"
printf "Feel free to try \"${RED}masterrc aptt${R}\" in a Terminal. It updates everything.\n"
printf "Also.. you can run \"${RED}masterrc help${R}\" to see all available commands.\n\nReload your shell with: ${RED}source ~/.bashrc${R}\n\n"






















