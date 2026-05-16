#!/usr/bin/env bash



# Custom:
# MrKoby07 was hereee

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


has_cmd() { # see if command exists or not
  command -v "$1" >/dev/null 2>&1 || command -v "$2" >/dev/null 2>&1
}





# check if user is root or if they are in termux. now I can replace every sudo command with $sudo, yayy :D
if [ "$(id -u)" -eq 0 ] || [ -n "${TERMUX_VERSION:-}" ] || [[ "${PREFIX:-}" == *com.termux* ]]; then
    sudo=""
else
    sudo="sudo"
fi



# check if the user is using termux or anything else to use to right bin for termux compatibility. (still got some other stuff in it :/)
# TODO: make this prettier.
if [ -n "${TERMUX_VERSION:-}" ] || [[ "${PREFIX:-}" == *com.termux* ]]; then
    nerdfetch_target="${PREFIX:-/data/data/com.termux/files/usr}/bin/nerdfetch"
    nerdfetch_chmod="a+x"
    is_termux_usr="${PREFIX:-/data/data/com.termux/files/usr/}"
else
    nerdfetch_target="/usr/bin/nerdfetch"
    nerdfetch_chmod="u+x"
    is_termux_usr="/usr"
fi



# helper priority list:
helper=""

if has_cmd cachy-update $is_termux_usr/bin/cachy-update; then
  helper="cachy"
elif has_cmd paru $is_termux_usr/bin/paru; then
  helper="paru"
elif has_cmd yay $is_termux_usr/bin/yay; then
  helper="yay"
elif has_cmd pikaur $is_termux_usr/bin/pikaur; then
  helper="pikaur"
elif has_cmd pacman $is_termux_usr/bin/pacman; then
  helper="pacman"
fi

# If you want to force a helper:
#helper=""






fortune_any() {
  if [ -x $is_termux_usr/bin/fortune ]; then
    $is_termux_usr/bin/fortune "$@"
  elif [ -x $is_termux_usr/games/fortune ]; then
    $is_termux_usr/games/fortune "$@"
  else
    # fallback: if fortune is in PATH under some other layout
    if command -v fortune >/dev/null 2>&1; then
      fortune "$@"
    else
      echo "fortune: command not found" >&2
      return 127
    fi
  fi
}



nerdfetch_font_flag() { # Check for what nerdfetch compatible font is installed
  # Check for any Nerd Font

  if has_cmd fc-list $is_termux_usr/bin/fc-list; then
    if fc-list | grep -qi "nerd"; then
      # Nerd Font found → output nothing (success, empty)
      return 0
    fi

    # Check for Cozette
    if fc-list | grep -qi "cozette"; then
      echo "-c"
      return 0
    fi

    # Check for Phosphor
    if fc-list | grep -qi "phosphor"; then
      echo "-p"
      return 0
    fi
  fi

  # None found
  echo "-e"
}
flag="$(nerdfetch_font_flag)"






sudo_nopass() {
  if [ "$is_termux_usr" = "/usr" ]; then
    sudo -n true 2>/dev/null
  fi
}




# So nerdfetch doesn't need a password to run :3
# Makes starting a new terminal much simpler and faster.
# It runs right after sudo is added just so it's very convenient!
# Run "nerdfetch_passwd" to restore it once.
nerdfetch_nopasswd() {
  local u f line
  u="$USER"
  f="/etc/sudoers.d/nerdfetch-$u"
  line="$u ALL=(root) NOPASSWD: $is_termux_usr/bin/nerdfetch"

  $sudo sh -c '
    f="$1"
    line="$2"

    # Skip if the exact line already exists
    if ! grep -qx "$line" "$f" 2>/dev/null; then
      echo "$line" >>"$f"
      # Validate sudoers fragment; visudo -c/-f is the safe way to check syntax
      visudo -cf "$f" >/dev/null 2>&1
    fi
  ' sh "$f" "$line" >/dev/null 2>&1
}



nerdfetch_passwd() { # enable password use for nerdfetch
  local u f
  u="$USER"
  f="/etc/sudoers.d/nerdfetch-$u"

  $sudo sh -c '
    f="$1"
    if [ -f "$f" ]; then
      rm -f "$f"
    fi
  ' sh "$f" >/dev/null 2>&1
  printf "\nNerdfetch now needs a password again\n(until next time aptt runs, edit ${RED}~/.bash_custom${R} directly to remove if you want to)\n"
}




spinner() { # hacker tool install
  local pid=$1 msg=$2
  local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0

  tput civis 2>/dev/null || true
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s %s" "${spin:i++%${#spin}:1}" "$msg"
    sleep 0.1
  done
  printf "\r%*s\r" $(( ${#msg} + 2 )) ""
  tput cnorm 2>/dev/null || true
}





hack-install() {
  set +m   # disable job control messages
  echo Verify...
  $sudo -v
  sudo apt install cmatrix btop -y > /dev/null 2>&1 </dev/null
  echo
  ( sleep 10 ) &
  spinner $! Installing...
  clear
  printf "\n\n\n\n\n\n"
  printf -- "${CYAN}-----------------------------------------------------${R}\n"
  printf "\n${GREEN}Successfully installed and enabled all Hacking Tools"'!'"${R}\n        use: hack, hacking, hacker-interface\n\n"
  printf -- "${CYAN}-----------------------------------------------------${R}\n"
  printf "\n\n\n\n\n\n"
}
shopt -s expand_aliases
alias hack-tools="hack-install"
alias hackers="hack-install"
alias hack-device="hack-install"
alias hacker-install="hack-install"
alias hacking-install="hack-install"





discord-install() { # Discord install command

  if has_cmd $is_termux_usr/bin/apt apt; then
    local api_url final_url remote_ver installed_ver tmp

    api_url="https://discord.com/api/download/stable?platform=linux&format=deb"
    final_url="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$api_url")"

    printf -- "\n${BLUE}------------------------------\n"
    printf "Installing Discord...\n\n"

    tmp="$(mktemp /tmp/discord-XXXXXX.deb)"
    wget -q --show-progress "$api_url" -O "$tmp"
    $sudo apt install -y "$tmp"
    rm -f "$tmp"
  fi

}






discord-update() { # Discord update command

   if has_cmd $is_termux_usr/bin/apt apt; then
      printf -- "\n${BLUE}------------------------------\n"
      printf "Checking Discord...\n\n"


      local api_url final_url remote_ver installed_ver installed_status tmp

      api_url='https://discord.com/api/download/stable?platform=linux&format=deb'
      installed_status="$(dpkg-query -W -f='${Status}' discord 2>/dev/null || true)"

      if [ "$installed_status" != "install ok installed" ]; then
        echo "Discord is not installed. Skipping Discord update."
      else
        installed_ver="$(dpkg-query -W -f='${Version}' discord 2>/dev/null || true)"
        final_url="$(command curl -fsSI -L "$api_url" | awk 'BEGIN{IGNORECASE=1} /^location:/ {print $2}' | tail -n1 | tr -d '\r')" || return 1
        remote_ver="$(grep -oE '[0-9]+\.[0-9]+\.[0-9]+' <<< "$final_url" | head -n1)"

        if [ -z "$remote_ver" ]; then
          echo "Could not determine latest Discord version."
          return 1
        elif dpkg --compare-versions "$installed_ver" eq "$remote_ver"; then
          echo "Discord is already up to date ($installed_ver)."
        else
          echo "Installing Discord $remote_ver..."
          tmp="$(mktemp /tmp/discord-XXXXXX.deb)" || return 1
          wget -q --show-progress "$api_url" -O "$tmp" || { rm -f "$tmp"; return 1; }
          $sudo apt install -y "$tmp" || { rm -f "$tmp"; return 1; }
          rm -f "$tmp"
        fi
      fi
    fi
}






aptt() { # This is the Main update command. It updates pretty much everything. We got: APT, Flatpak, Discord, other package managers, masterrc.. list goes on and on.

  if has_cmd $is_termux_usr/bin/update update; then
    printf -- "\n${YELLOW}------------------------------\n"
    printf "Trying Update command...\n\n"
      $sudo update
  fi


  if ! sudo_nopass; then
    printf -- "\n${RED}------------------------------\n"
    printf "Authenticating...\n\n"
    sudo -v
  fi

  if has_cmd nerdfetch $is_termux_usr/bin/nerdfetch; then
    nerdfetch_nopasswd
  fi

  # 100% always updating masterrc
  printf -- "\n${PURPLE}------------------------------\n"
  printf "Updating Masterrc...\n\n"
  bash <(curl -fsSL https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/install.sh)


  if [ -f "$HOME/uia/uia.sh" ]; then
    printf -- "\n${WHITE}------------------------------\n"
    printf "Updating UIA...\n\n"
    masterrc uuuia
  fi

# Checking for package manager and Updating that one.
  if has_cmd $is_termux_usr/bin/flatpak flatpak; then
    if ! has_cmd $is_termux_usr/bin/cachy-update cachy-update; then
      printf -- "\n${YELLOW}------------------------------\n"
      printf "Updating Flatpak...\n\n"
      flatpak update
    fi
  fi

  if has_cmd $is_termux_usr/bin/apt apt; then
    printf -- "\n${WHITE}------------------------------\n"
    printf "Updating APT...\n\n"
    $sudo apt update
  fi


  if has_cmd $is_termux_usr/bin/pacman pacman; then
    printf -- "\n${WHITE}------------------------------\n"
    printf "Updating ${helper}...\n\n"
    if [ "$helper" = "pacman" ]; then
      $sudo pacman -Syu
    elif [ "$helper" = "cachy" ]; then
      cachy-update
    else
      "$helper" -Syu
    fi
  fi


  if has_cmd $is_termux_usr/bin/dnf dnf; then
    printf -- "\n${BLUE}------------------------------\n"
    printf "Updating Dnf...\n\n"
    $sudo dnf upgrade --refresh
  fi


  if has_cmd $is_termux_usr/bin/zypper zypper; then
    printf -- "\n${GREEN}------------------------------\n"
    printf "Updating Zypper...\n\n"
    $sudo zypper refresh
    $sudo zypper update
  fi

  if has_cmd $is_termux_usr/bin/snap snap; then
    printf -- "\n${CYAN}------------------------------\n"
    printf "Refreshing Snap...\n\n"
    $sudo snap refresh
  fi


  # Discord update
  if has_cmd $is_termux_usr/bin/discord discord; then
    discord-update
  fi

  # Finishing APT upgrades
  if has_cmd $is_termux_usr/bin/apt apt; then
    printf -- "\n${GREEN}------------------------------\n"
    printf "Doing upgrade...\n\n"
    $sudo apt upgrade
  fi

  if has_cmd $is_termux_usr/bin/apt apt; then
    printf -- "\n${B_GREEN}------------------------------\n"
    printf "Doing full-upgrade...\n\n"
    $sudo apt full-upgrade
  fi

# Autoremove
  if has_cmd $is_termux_usr/bin/apt apt; then
    printf -- "\n${RED}------------------------------\n"
    printf "Doing autoremove...\n\n"
      $sudo apt autoremove
  fi

  if has_cmd $is_termux_usr/bin/dnf dnf; then
    printf -- "\n${RED}------------------------------\n"
    printf "Doing autoremove...\n\n"
      $sudo dnf autoremove
  fi

  if has_cmd $is_termux_usr/bin/pacman pacman; then
    if ! has_cmd $is_termux_usr/bin/cachy-update cachy-update; then
        orphans="$(pacman -Qdtq 2>/dev/null || true)"
        if [ -n "$orphans" ]; then
          printf -- "\n${RED}------------------------------\n"
          printf "Doing autoremove...\n\n"
          printf '%s\n' "$orphans"
          $sudo pacman -Rns $orphans
        else
          printf -- "\n${RED}------------------------------\n"
          printf "Doing autoremove...\n\n"
          echo "No pacman autoremove candidates found."
        fi
    fi
  fi


  # TODO: make the /usr/ directory always decided on if it's termux or not. for compatibility
  printf  "\n\n${PURPLE}Updated Everything, Enjoy :D\n"
  if has_cmd $is_termux_usr/bin/fortune fortune; then
    printf "Have a fortune :3\n\n${R}"
    if ! has_cmd $is_termux_usr/bin/cowsay cowsay; then
      printf '"\n'
      fortune_any
      printf '"\n'
    else
      fortune_any | $is_termux_usr/bin/cowsay -f sheep
    fi
  fi
  printf "\n\n"

  printf "${R}"
}






ugit() { # quick github upload

  if has_cmd $is_termux_usr/bin/git git; then
    git pull
    git add .
    git commit
    git push

    git status
  fi
}





# TODO: add nerdfont install
feature() { # install additional features like fortune or nerdfetch.

# Apt
  if has_cmd $is_termux_usr/bin/apt apt; then
    # Install fortune if missing
    if ! has_cmd $is_termux_usr/bin/fortune $is_termux_usr/games/fortune; then
      echo "              ----------------"
      echo "Installing Fortune..."
      echo
      $sudo apt install -y fortune-mod > /dev/null 2>&1 </dev/null
      echo "Fortune installed."
    fi
  fi

# Pacman

  if has_cmd $is_termux_usr/bin/pacman pacman; then
    # Install fortune if missing
    if ! has_cmd $is_termux_usr/bin/fortune $is_termux_usr/games/fortune; then
      echo "              ----------------"
      echo "Installing Fortune..."
      echo
      $sudo pacman -S --noconfirm fortune-mod > /dev/null 2>&1 </dev/null
      echo "Fortune installed."
    fi
  fi

  # install nerdfetch if missing
  if ! has_cmd $is_termux_usr/bin/nerdfetch $is_termux_usr/bin/nerdfetch; then
    if ! has_cmd $is_termux_usr/bin/yay $is_termux_usr/bin/yay; then
      echo "              ----------------"
      echo "Installing nerdfetch..."
      $sudo curl -fsSL "https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch" -o "$nerdfetch_target" > /dev/null 2>&1 </dev/null
      $sudo chmod "$nerdfetch_chmod" "$nerdfetch_target" > /dev/null 2>&1 </dev/null
      echo
      echo "Nerdfetch installed."
      echo
    else
      echo "              ----------------"
      echo "Installing nerdfetch..."
      yay -S --noconfirm nerdfetch > /dev/null 2>&1 </dev/null
      echo
      echo "Nerdfetch installed."
      echo

    fi
    printf "\nNow run ${PURPLE}welcome${R} to see what changed :3"
  fi

  # Both present = info message
  if has_cmd fortune $is_termux_usr/games/fortune && has_cmd nerdfetch $is_termux_usr/bin/nerdfetch; then
    printf "\nFeatures already installed, run ${PURPLE}welcome${R} to see what it is :3\n\n"
  fi


}


# Upload Internet Archive Commands:
uia_setup() { # Initial Setup for UIA
  cat > "$HOME/channels.txt" << 'EOF'

# Add The Channels that you Downloaded via MeTube above this line.
# This Script is made for the downloads to be stored at /opt/metube_downloads/[channel_name]
EOF
  nano "$HOME/channels.txt"
  printf "\nYou created the channels.txt file.\nNow you can run ${RED}uia${R} to upload the channels you downloaded to the Internet Archive :D\nEdit channels.txt whenever you want at ${GREEN}${HOME}/channels.txt${R}\n\n"
}


uia() { # UIA Script itself, uploads to Internet Archive.
  if [[ ! -x "$HOME/uia/uia.sh" ]]; then
    printf "Upload Internet Archive is giving an error. Try installing it with ${RED}uuia${R} first.\n\nDon't know what it is?\nCheck here: ${BLUE}https://gist.github.com/Master3307/167a0ebf150ec72aae1c26d008a84fde${R}\n\n"
  else
    $HOME/uia/uia.sh
    echo "Finished uploading. (If this is your only output, it means that you didn't set anything in channels.txt)"
  fi
}


uuia() { # Installs UIA. Only run once.
  git clone "https://gist.github.com/Master3307/167a0ebf150ec72aae1c26d008a84fde" ~/uia/ # Clone the Repo
  chmod +x ~/uia/uia.sh # Ensure Permissions
}


uuuia() { # Update UIA. I know, It's really primitive :/
  rm -rf $HOME/uia
  git clone "https://gist.github.com/Master3307/167a0ebf150ec72aae1c26d008a84fde" $HOME/uia/ # Clone the Repo
  chmod +x $HOME/uia/uia.sh # Ensure Permissions
}

uninstall-uia() {
  read -r -p 'Do you *really* want to uninstall UIA? [y/N] ' answer
  case "$answer" in
    [yY]|[yY][eE][sS])
      if [ -f "$HOME/uia/uia.sh" ]; then
          rm -rf "$HOME/uia/"
          echo
          echo "(hopefully) removed UIA files."
          if [ -f "$HOME/channels.txt" ]; then
              read -r -p 'Delete "channels.txt"? [y/N] ' answer
              case "$answer" in
                  [yY]|[yY][eE][sS])
                      rm -vf "$HOME/channels.txt"
                      ;;
              esac
          else
              echo "channels.txt does not exist."
              echo
          fi
      else
          echo "UIA is not installed."
      fi
      ;;
  esac
}





welcome() { # is the only visible thing at launch.  welcome message.
  printf "\n"

  if has_cmd nerdfetch "$nerdfetch_bin"; then
    $sudo "$nerdfetch_bin" "$flag"           # change this if you need. if you use nerdfont, remove the flag. if you use cozette, use -c. and if you use phosphor, use -p. if you use none of this, use -e. (usually automatic)
  fi

  printf "\n"

  if has_cmd fortune $is_termux_usr/games/fortune; then
    fortune_any # had to remove -a flag. if you want offensive ones included, customize it.
    printf "\n\n\n"
  fi

  # Message 1
  local delay="${2:-0.01}"
  local char
  while IFS= read -r -n1 char; do
    printf "%s" "$char"
    sleep "$delay"
  done <<< "$(printf '\033[31m- \033[0;33mWelcome to the Terminal \033[1;35m%s\033[0m \033[31m-\033[0m' "${USER}")"
  printf "\n"

  # Message 2
  delay="${2:-0.01}"
  while IFS= read -r -n1 char; do
    printf "%s" "$char"
    sleep "$delay"
  done <<< "$(printf '\033[0;36mWhat magical thing might you do today?\033[0m')"
  printf "\n\n"
}












help() { # General Help Message. Shows all available commands that work with masterrc.


  printf "\n\n${B_BLUE}(Main) MasterRC commands:${R}\n"

  printf "  ${GREEN}help${R}  . . . . . . . . Show this help message\n"
  printf "  ${GREEN}welcome${R} . . . . . . . Show welcome message\n"
  printf "  ${GREEN}aptt${R}  . . . . . . . . Update everything (APT, Flatpak, Discord, etc.)\n"
  printf "  ${GREEN}masterrc${R}  . . . . . . Update/Reinstall masterrc\n"
  printf "  ${GREEN}feature${R} . . . . . . . Install additional features like fortune and nerdfetch\n\n"

  printf "  ${GREEN}ugit${R}  . . . . . . . . Quick GitHub upload (git add, commit, push)\n"
  printf "  ${GREEN}discord-update${R}  . . . Updates Discord in ${RED}Debian${R} Systems\n"
  printf "  ${GREEN}discord-install${R} . . . Install Discord in ${RED}Debian${R} Systems\n"


  printf "\n${RED}(Some) Advanced commands:${R}\n"

  # TODO: make it more organized
  printf "  ${GREEN}uuia${R}  . . . . . . . . Install Upload Internet Archive (only run once.)\n"
  printf "  ${GREEN}uuuia${R} . . . . . . . . Update Upload Internet Archive\n"
  printf "  ${GREEN}uninstall-uia${R} . . . . Uninstall Upload Internet Archive\n"
  printf "  ${GREEN}suia${R}  . . . . . . . . Setup Upload Internet Archive for the first time\n"
  printf "  ${GREEN}uia${R} . . . . . . . . . Upload Internet Archive (requires setup)\n\n"


  printf "\nFor more info, visit the docs: ${BLUE}https://masterrc-docs.master3307.org/usage${R}\n\n"


}








main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
  # Main commands
    welcome) welcome ;;  
    help)    help ;;
    aptt)    aptt ;;
    masterrc) bash <(curl -fsSL https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/install.sh) ;;
    updates)  aptt ;;
    upgrades) aptt ;;
    feature) feature ;;
  
  # Other commands
    ugit)    ugit ;;
    discord-update) discord-update ;;
    discord-install) discord-install ;;

  # UIA commands
    uia)     uia ;;
    uuia)    uuia;;
    uuuia)   uuuia;;
    uninstall-uia) uninstall-uia ;;
    suia)    uia_setup ;;
  
    *)       printf "Unknown command: ${cmd}\n\ntry ${RED}masterrc help${R}\nor visit the docs: ${BLUE}https://masterrc-docs.master3307.org${R}\n\n"; return 1;;
  esac
}


main "$@"

# hi :) 
# how are ya? :D
