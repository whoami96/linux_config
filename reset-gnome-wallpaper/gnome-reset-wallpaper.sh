#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# reset-gnome-wallpaper.sh — Reset GNOME wallpaper after resume (manual trigger)
# Author:   WhoAmI
# Distro:   Fedora (GNOME, Wayland)
# Location: ~/.local/bin/reset-gnome-wallpaper.sh or repo/scripts/
# -----------------------------------------------------------------------------
# Why:
# - Sometimes after suspend/resume GNOME shows a black background instead of
#   the current wallpaper.
# - This script forces GNOME to re-apply the wallpaper values using gsettings.
# - Run it manually (alias `fixwall`) or bind to a hotkey.
# -----------------------------------------------------------------------------

set -euo pipefail
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

bg_schema="org.gnome.desktop.background"
ss_schema="org.gnome.desktop.screensaver"

# Re-apply current wallpaper (light & dark variants)
for key in picture-uri picture-uri-dark; do
  if gsettings writable "$bg_schema" "$key" >/dev/null 2>&1; then
    val="$(gsettings get "$bg_schema" "$key")"
    gsettings set "$bg_schema" "$key" "$val"
  fi
done

# Re-apply lockscreen wallpaper if available
if gsettings writable "$ss_schema" picture-uri >/dev/null 2>&1; then
  val="$(gsettings get "$ss_schema" picture-uri)"
  gsettings set "$ss_schema" picture-uri "$val"
fi

# Force repaint via picture-options
if gsettings writable "$bg_schema" picture-options >/dev/null 2>&1; then
  opt="$(gsettings get "$bg_schema" picture-options)"
  gsettings set "$bg_schema" picture-options "$opt"
fi

# Notify user
if command -v notify-send >/dev/null 2>&1; then
  notify-send "Wallpaper fixed ✅" "GNOME background has been refreshed."
else
  echo "Wallpaper fixed ✅"
fi
