# dotfiles
Hyprland/Waybar/Kitty/Rofi + temas y scripts.
## Restore rápido (GNU Stow)

sudo pacman -S stow
cd ~/dotfiles
stow -v -t "$HOME" .config
stow -v -t "$HOME" .local
stow -v -t "$HOME" .
