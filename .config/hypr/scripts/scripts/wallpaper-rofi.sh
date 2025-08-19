#!/usr/bin/env bash
set -euo pipefail

WPDIR="${HOME}/Imágenes/Wallpapers/Aesthetic/"
mkdir -p "$WPDIR"

command -v swww >/dev/null || { echo "swww no instalado"; exit 1; }
pgrep -x swww-daemon >/dev/null || swww-daemon &

ROFI_BASE="$HOME/.config/hypr/scripts/rofi/waybar-switcher.rasi"

# si tu .rasi no tiene el import de wal, lo agregamos al principio
if ! grep -q 'colors-rofi' "$ROFI_BASE" 2>/dev/null; then
  if   [ -f "$HOME/.cache/wal/colors-rofi-dark.rasi" ]; then
    sed -i '1i @import "~/.cache/wal/colors-rofi-dark.rasi"' "$ROFI_BASE"
  elif [ -f "$HOME/.cache/wal/colors-rofi.rasi" ]; then
    sed -i '1i @import "~/.cache/wal/colors-rofi.rasi"' "$ROFI_BASE"
  fi
fi

pick() {
  local finder='find "'"$WPDIR"'" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) | sort'
  if command -v rofi >/dev/null; then
    eval "$finder" | rofi -dmenu -i -p "Wallpaper" -theme "$ROFI_BASE"
  else
    eval "$finder" | wofi --dmenu -p "Wallpaper"
  fi
}

img="$(pick || true)"; [[ -z "${img:-}" ]] && exit 0

swww img "$img" --transition-type grow --transition-duration 0.6

# paleta con wal (silencioso, sin cambiar fondo)
command -v wal >/dev/null && wal -n -q -i "$img" || true
# (opcional) wallust
command -v wallust >/dev/null && wallust run "$img" || true

# integraciones propias (opcional)
if [[ -x "$HOME/.config/hypr/scripts/integrations/gen_palette.py" ]]; then
  python3 "$HOME/.config/hypr/scripts/integrations/gen_palette.py" \
    "$HOME/.config/waybar/temas/integrations/palette.css" >/dev/null 2>&1 || true
fi

# recargar barras/Hyprland para tomar colores
pkill -USR2 waybar 2>/dev/null || { pkill waybar 2>/dev/null; nohup waybar >/dev/null 2>&1 & }
command -v hyprctl >/dev/null && hyprctl reload || true

command -v notify-send >/dev/null && notify-send "Wallpaper" "Aplicado: $(basename "$img")" || true
