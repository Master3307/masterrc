#!/usr/bin/env bash
set -euo pipefail

PROFILE_DIR="$HOME/.local/share/konsole"
PROFILE_FILE="$PROFILE_DIR/Main.profile"

FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="JetBrainsMono"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
FONT_ZIP="$FONT_DIR/${FONT_NAME}NF.zip"


echo "==> Installing Nerd Font: ${FONT_NAME} (JetBrainsMono Nerd Font)"
mkdir -p "$FONT_DIR"
curl -fsSL "$FONT_URL" -o "$FONT_ZIP"
unzip -o "$FONT_ZIP" -d "$FONT_DIR" >/dev/null 2>&1 || true
rm -f "$FONT_ZIP"

if command -v fc-cache >/devnull 2>&1; then
  echo "==> Refreshing font cache"
  fc-cache -f "$FONT_DIR" || true
fi

echo "==> Writing Konsole profile to $PROFILE_FILE"
mkdir -p "$PROFILE_DIR"

cat > "$PROFILE_FILE" <<'EOF'
[Appearance]
AntiAliasFonts=true
BorderWhenActive=false
ColorScheme=MateriaDark
Font=JetBrainsMonoNL Nerd Font Mono,10,-1,5,700,1,0,0,0,0,0,0,0,0,0,1,Bold Italic
LineSpacing=0

[Cursor Options]
CursorShape=1

[General]
DimWhenInactive=false
Icon=gksu-root-terminal
Name=Main
Parent=FALLBACK/
SemanticUpDown=false
TerminalCenter=true
TerminalMargin=0

[Scrolling]
HistoryMode=2
ScrollBarPosition=2

[Terminal Features]
BlinkingCursorEnabled=true
EOF
echo "==> Adding Flathub remote (if needed)"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "==> Installing Materia GTK themes from Flathub"
flatpak install -y flathub org.gtk.Gtk3theme.Materia{,-dark,-light}{,-compact}
echo "==> Done."
echo "    Restart Konsole, select profile \"Main\" and use the MateriaDark color scheme."
