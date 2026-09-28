#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title ANC Transparent
# @vicinae.mode silent
# @vicinae.icon 🌬️
# @vicinae.packageName Realme Buds

if python3 "$HOME/bin/vicinae/realme_anc.py" transparent; then
    notify-send -e "ANC" "Transparent Mode" -i "/home/kobe/.local/share/vicinae/favicon-data/airpods.png" -a "ANC Switcher"
else
    notify-send -e "ANC" "Failed to switch mode" -i "/home/kobe/.local/share/vicinae/favicon-data/airpods.png" -a "ANC Switcher"
fi
