#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title ANC Off
# @vicinae.mode silent
# @vicinae.icon 🔊
# @vicinae.packageName Realme Buds

if python3 "$HOME/bin/vicinae/realme_anc.py" normal; then
    notify-send -e "ANC" "Normal (ANC OFF)" -a "ANC Switcher" -i "/home/kobe/.local/share/vicinae/favicon-data/airpods.png"
else
    notify-send -e "ANC" "Failed to switch mode" -a "ANC Switcher" -i "/home/kobe/.local/share/vicinae/favicon-data/airpods.png"
fi
