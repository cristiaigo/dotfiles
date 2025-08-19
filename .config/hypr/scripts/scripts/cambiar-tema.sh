#!/bin/bash

# 1. Carpeta con wallpapers
WALLPAPERS_DIR="$HOME/Imágenes/Wallpapers/Aesthetic"
WALLPAPER=$(find "$WALLPAPERS_DIR" -type f | shuf -n 1)

# 2. Cambiar el wallpaper con transición
swww img "$WALLPAPER" --transition-type outer --transition-fps 255 --transition-duration 0.8

# 3. Generar la paleta de colores con pywal
wal -i "$WALLPAPER" -q

# 4. Cargar variables de color generadas
source "$HOME/.cache/wal/colors.sh"

# 5. Aplicar colores dinámicos a Hyprland
hyprctl keyword general:col.active_border "rgb(${color4:1}) rgb(${color2:1}) 45deg"
hyprctl keyword general:col.inactive_border "rgb(${color8:1})"

# 6. Reiniciar Waybar (superior e inferior si hay)
pkill waybar
waybar &
# waybar -c ~/.config/waybar/config-dock.jsonc -s ~/.config/waybar/style-dock.css &

