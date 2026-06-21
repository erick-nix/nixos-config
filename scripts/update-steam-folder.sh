#!/usr/bin/env bash
set -euo pipefail

DESKTOP_DIR="$HOME/.local/share/applications"
SCHEMA="org.gnome.desktop.app-folders.folder"
PATH_STEAM="/org/gnome/desktop/app-folders/folders/Steam/"

APPS=()

while IFS= read -r file; do
  APPS+=( "$(basename "$file")" )
done < <(grep -rl "Exec=.*steam://" "$DESKTOP_DIR" 2>/dev/null || true)

[ "${#APPS[@]}" -eq 0 ] && exit 0

GVARIANT="["
for app in "${APPS[@]}"; do
  esc="${app//\'/\\\'}"
  GVARIANT+="'$esc', "
done
GVARIANT="${GVARIANT%, }]"
  
gsettings set "$SCHEMA:$PATH_STEAM" name 'Steam'

gsettings set "$SCHEMA:$PATH_STEAM" apps "$GVARIANT"

