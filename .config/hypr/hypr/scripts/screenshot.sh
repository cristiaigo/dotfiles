#!/usr/bin/env bash
set -euo pipefail
DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
mkdir -p "$DIR"
fn="${1:-$(date +'%Y-%m-%d_%H-%M-%S').png}"
mode="${2:-area}"
path="$DIR/$fn"

case "$mode" in
  area) region="$(slurp)"; grim -g "$region" "$path" ;;
  full) grim "$path" ;;
  *)    region="$(slurp)"; grim -g "$region" "$path" ;;
esac

notify-send "Captura guardada" "$path"
command -v swappy >/dev/null && swappy -f "$path" || true
