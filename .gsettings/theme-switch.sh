#!/usr/bin/env sh
set -euo

# Add wallpaper setting

if test "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-light'"; then
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark
  dconf write /org/gnome/shell/extensions/user-theme/name "'Marble-purple-dark'"
  gsettings set org.gnome.desktop.background picture-uri-dark file:///home/lanhild/Pictures/Wallpapers/dark.jpg
else
  gsettings set org.gnome.desktop.interface color-scheme prefer-light
  dconf write /org/gnome/shell/extensions/user-theme/name "'Marble-blue-light'"
  gsettings set org.gnome.desktop.background picture-uri file:///home/lanhild/Pictures/Wallpapers/light.jpg
fi
