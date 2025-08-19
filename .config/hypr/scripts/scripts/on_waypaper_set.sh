#!/usr/bin/env bash
set -euo pipefail

IMG="${1:-}"; [[ -z "$IMG" ]] && exit 0

# 1) Generar paleta (wal crea colors-hyprland.conf y colors-waybar.css en ~/.cache/wal)
wal -n -q -i "$IMG"

# 2) Hyprland: recargar para que tome ~/.cache/wal/colors-hyprland.conf (ya lo sourceás en tu hyprland.conf)
command -v hyprctl >/dev/null && hyprctl reload || true

# 3) Kitty (si hay remote control)
kitty @ set-colors -a "$HOME/.cache/wal/colors-kitty.conf" 2>/dev/null || true

# 4) Waybar: relanzar SOLO si el tema actual es dinámico
THEMES_DIR="$HOME/.config/waybar/temas"
CUR_FILE="$THEMES_DIR/.current"
if [[ -f "$CUR_FILE" ]]; then
  theme="$(<"$CUR_FILE")"
  lo="$(printf '%s' "$theme" | tr '[:upper:]' '[:lower:]')"
  if [[ "$lo" == *dinam* || "$lo" == *dynamic* || "$lo" == *pywal* || "$lo" == *wallust* ]]; then
    conf="$THEMES_DIR/$theme/config.jsonc"
    css="$THEMES_DIR/$theme/style.css"
    # matar y relanzar con rutas explícitas
    pkill -TERM -x waybar 2>/dev/null || true
    sleep 0.3
    pgrep -x waybar >/dev/null && pkill -KILL -x waybar || true
    sleep 0.1
    if [[ -f "$conf" && -f "$css" ]]; then
      nohup waybar -c "$conf" -s "$css" >/dev/null 2>&1 &
    else
      nohup waybar >/dev/null 2>&1 &
    fi
  fi
fi
