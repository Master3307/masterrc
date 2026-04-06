#!/usr/bin/env bash
set -euo pipefail

BASH_CUSTOM_URL="https://server.master3307.org/share/bash/.bash_custom"
TARGET_FILE="$HOME/.bash_custom"
BASHRC_FILE="$HOME/.bashrc"
SOURCE_LINE='[ -f "$HOME/.bash_custom" ] && source "$HOME/.bash_custom"'

echo "==> Installing dependencies (flatpak, fortune-mod, nerdfetch)..."

if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y flatpak fortune-mod
else
  echo "!! apt not found. Please install flatpak and fortune-mod manually."
fi

if ! command -v nerdfetch >/dev/null 2>&1; then
  echo "==> Installing nerdfetch..."
  sudo curl -fsSL "https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch" -o /usr/bin/nerdfetch
  sudo chmod u+x /usr/bin/nerdfetch
else
  echo "==> nerdfetch already installed."
fi

echo "==> Downloading ~/.bash_custom"
curl -fsSL "$BASH_CUSTOM_URL" -o "$TARGET_FILE"

if [ ! -f "$BASHRC_FILE" ]; then
  touch "$BASHRC_FILE"
fi

if ! grep -Fqx "$SOURCE_LINE" "$BASHRC_FILE"; then
  printf '\n%s\n' "$SOURCE_LINE" >> "$BASHRC_FILE"
  echo "==> Added source line to ~/.bashrc"
else
  echo "==> Source line already present in ~/.bashrc"
fi

echo "==> Done. Reload your shell with:"
echo "    source ~/.bashrc"