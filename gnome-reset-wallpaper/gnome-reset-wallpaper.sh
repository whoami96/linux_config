#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# gnome-reset-wallpaper.sh — Reset GNOME wallpaper after resume (Wayland)
# Distro: Fedora 42
# User:   whoami
# Why:    Workaround for black background after suspend/resume by re-applying
#         the current wallpaper via gsettings. This forces GNOME to repaint.
# -----------------------------------------------------------------------------
# Notes:
# - Runs automatically via systemd's system-sleep hooks with args: pre|post.
# - Safe to run multiple times; it re-sets the current value to itself.
# - Talks to the user's session D-Bus from root via DBUS_SESSION_BUS_ADDRESS.
# -----------------------------------------------------------------------------
set -euo pipefail

log() { logger -t gnome-reset-wallpaper -- "$*"; }

USER_NAME="whoami"

case "${1:-}/${2:-}" in
  post/*)
    # Give GNOME a moment to restore the session graphics stack.
    sleep 2

    # Build user session DBus address.
    UID_NUM="$(id -u "$USER_NAME")"
    DBUS_ADDR="unix:path=/run/user/${UID_NUM}/bus"

    # Read current wallpaper URIs (strip quotes) using user's session.
    uri="$(sudo -u "$USER_NAME" env DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
      gsettings get org.gnome.desktop.background picture-uri | tr -d "'")" || true

    uri_dark="$(sudo -u "$USER_NAME" env DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
      gsettings get org.gnome.desktop.background picture-uri-dark | tr -d "'")" || true

    # Re-apply to force repaint (skip if empty).
    if [[ -n "$uri" ]]; then
      sudo -u "$USER_NAME" env DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
        gsettings set org.gnome.desktop.background picture-uri "$uri" || true
    fi
    if [[ -n "$uri_dark" ]]; then
      sudo -u "$USER_NAME" env DBUS_SESSION_BUS_ADDRESS="$DBUS_ADDR" \
        gsettings set org.gnome.desktop.background picture-uri-dark "$uri_dark" || true
    fi

    log "Wallpaper reset after resume for user $USER_NAME"
    ;;
  *)
    # pre/* or anything else — do nothing.
    ;;
esac
