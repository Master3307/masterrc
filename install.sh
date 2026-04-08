#!/usr/bin/env bash
set -euo pipefail

BASH_CUSTOM_URL="https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/.bash_custom"
PROFILE_URL="https://raw.githubusercontent.com/Master3307/masterrc/refs/heads/master/profile.sh"

TARGET_FILE="$HOME/.bash_custom"
MASTERRC_DIR="$HOME/.masterrc"
PROFILE_FILE="$MASTERRC_DIR/profile.sh"

BASHRC_FILE="$HOME/.bashrc"
SOURCE_LINE='[ -f "$HOME/.bash_custom" ] && source "$HOME/.bash_custom"'

echo "------------------------------"
echo "Installing dependencies (flatpak, fortune-mod, nerdfetch)..."
echo

if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y fortune-mod
else
  echo "Failed"
fi

if ! command -v nerdfetch >/dev/null 2>&1; then
  echo "------------------------------"
  echo "Installing nerdfetch..."
  sudo curl -fsSL "https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch" -o /usr/bin/nerdfetch
  sudo chmod u+x /usr/bin/nerdfetch
  echo
else
  echo
  echo "nerdfetch already installed."
fi

echo "------------------------------"
echo "Downloading ~/.bash_custom"
curl -fsSL "$BASH_CUSTOM_URL" -o "$TARGET_FILE"
echo

# NEW: fetch profile.sh into ~/.masterrc/
echo "------------------------------"
echo "Downloading profile.sh to ~/.masterrc/profile.sh"
mkdir -p "$MASTERRC_DIR"
curl -fsSL "$PROFILE_URL" -o "$PROFILE_FILE"
chmod +x "$PROFILE_FILE"
echo

if [ ! -f "$BASHRC_FILE" ]; then
  touch "$BASHRC_FILE"
fi

if ! grep -Fqx "$SOURCE_LINE" "$BASHRC_FILE"; then
  printf '\n%s\n' "$SOURCE_LINE" >> "$BASHRC_FILE"
  echo
  echo "Added source line to ~/.bashrc"
  echo
else
  echo
  echo "Source line already present in ~/.bashrc"
  echo
fi

echo
echo
echo "Done. Reload your shell with:"
echo "    source ~/.bashrc"
echo
echo "... and have fun with whatever you just installed :3"
echo
echo '    Feel free to try "aptt" in a Terminal. It updates everything.'
echo '    You can also run "masterrc" to update the Script itself (it runs this again)'

