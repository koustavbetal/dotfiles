#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Night Light Toggle
# @vicinae.mode silent

SCHEMA="org.gnome.settings-daemon.plugins.color"
KEY="night-light-enabled"

current=$(gsettings get $SCHEMA $KEY)
new=$([ "$current" = "true" ] && echo false || echo true)
gsettings set $SCHEMA $KEY $new
notify-send -e "Night Light" "$([ "$new" = "true" ] && echo "ON" || echo "OFF")" -a "Night Light Tool" -i "/home/kobe/.local/share/vicinae/favicon-data/monitor.png"

