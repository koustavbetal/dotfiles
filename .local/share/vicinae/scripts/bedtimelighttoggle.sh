#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title Bedtime Toggle
# @vicinae.mode silent

schema_id=org.gnome.shell.extensions.bedtime-mode
schema_dir=~/.local/share/gnome-shell/extensions/gnomebedtime@ionutbortis.gmail.com/schemas/

if [[ $(gsettings --schemadir $schema_dir get $schema_id bedtime-mode-active) == true ]]; then
    turn_on=false
else
    turn_on=true
fi

gsettings --schemadir $schema_dir set $schema_id bedtime-mode-active $turn_on
notify-send -e "Bedtime Mode" "$([ "$turn_on" = "true" ] && echo "ON" || echo "OFF")" -a "Bedtime Mode Tool" -i "/home/kobe/.local/share/vicinae/favicon-data/sleep.png"
