#!/usr/bin/env bash
set -euo pipefail

THEMES_DIR="$HOME/.config/waybar/temas"
CUR_FILE="$THEMES_DIR/.current"     # contiene el nombre del tema, ej: "dinamico" o "mi-tema"
CSS_CACHE="$HOME/.cache/wal/colors-waybar.css"
CSS_LINK="$HOME/.config/waybar/colors.css"

# Link estable para colores (si existía de una sesión previa)
[[ -f "$CSS_CACHE" ]] && ln -sf "$CSS_CACHE" "$CSS_LINK"

# Lee tema actual y arma rutas
theme="$( [[ -f "$CUR_FILE" ]] && cat "$CUR_FILE" || echo "default" )"
conf="$THEMES_DIR/$theme/config.jsonc"
css="$THEMES_DIR/$theme/style.css"

# Lanza Waybar con TU config y TU CSS
if [[ -f "$conf" && -f "$css" ]]; then
  exec waybar -c "$conf" -s "$css"
else
  exec waybar
fi
