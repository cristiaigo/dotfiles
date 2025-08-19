#!/bin/bash

MONITOR="eDP-1"

opciones=(
  "1920x1080@144"
  "1920x1080@120"
  "1920x1080@60"
  "1920x1080@48"

  "1680x1050@60"
  "1600x900@60"
  "1440x900@60"
  "1366x768@60"
  "1280x800@60"
  "1280x720@60"
  "1024x768@60"
  "1024x576@60"
  "800x600@60"
  "640x480@60"
)

seleccion=$(printf "%s\n" "${opciones[@]}" | fzf --prompt="🖥 Seleccioná resolución y refresco: ")

if [ -n "$seleccion" ]; then
  hyprctl keyword monitor "$MONITOR,$seleccion,0x0,1"
  notify-send "🖥 Resolución aplicada" "$MONITOR -> $seleccion"
else
  notify-send "⚠️ Cambio cancelado"
fi
