#!/bin/bash
RED='\e[31m'
R='\e[0m'

printf "${RED}"
echo "Are you sure you want to uninstall MasterRC? (yes/no)"
read -r response
if [[ "$response" != "yes" ]]; then
    printf "${R}"
    echo "Uninstall cancelled."
    echo
    printf "${RED}"
    echo "How dare you even think about it? >:("
    echo
    echo
    sleep 3
    echo "Die!"
    sleep 1
    exit 1
else
    echo
    echo
    echo "why? D:"
    echo
    echo
    sleep 2
fi

echo "              ----------------"
echo "Uninstalling MasterRC..."
echo

# Remove ~/.bash_custom
if [ -f ~/.bash_custom ]; then
    rm ~/.bash_custom
    echo "~/.bash_custom removed"
else
    echo "~/.bash_custom does not exist"
fi

# Remove the source line from ~/.bashrc
BASHRC_FILE="$HOME/.bashrc"
SOURCE_LINE='[ -f "$HOME/.bash_custom" ] && source "$HOME/.bash_custom"'

if [ -f "$BASHRC_FILE" ]; then
    if grep -qF "$SOURCE_LINE" "$BASHRC_FILE"; then
        grep -vF "$SOURCE_LINE" "$BASHRC_FILE" > "$BASHRC_FILE.tmp" && mv "$BASHRC_FILE.tmp" "$BASHRC_FILE"
        echo "Removed source line from ~/.bashrc"
    else
        echo "Source line not found in ~/.bashrc"
    fi
else
    echo "~/.bashrc does not exist"
fi

echo
printf "${R}\nUninstalled MasterRC. Last note from the script:\n\n ${RED}I hope it was worth it...\n\n"