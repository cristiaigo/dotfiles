# dotfiles
Hyprland/Waybar/Kitty/Rofi + temas y scripts.

https://github.com/cristiaigo/dotfiles/issues/1#issue-3343529853


## Restore rápido (GNU Stow)

sudo pacman -S stow
cd ~/dotfiles
stow -v -t "$HOME" .config
stow -v -t "$HOME" .local
stow -v -t "$HOME" .
