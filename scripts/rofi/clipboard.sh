#!/usr/bin/env bash

# Check if cliphist is installed
if ! command -v cliphist &> /dev/null; then
    notify-send "Clipboard Manager" "cliphist is not installed!" -u critical
    exit 1
fi

# Rofi theme
ROFI_THEME="$HOME/.config/rofi/list.rasi"

# Get clipboard history and format it
# cliphist list returns: [timestamp] content
clipboard_list=$(cliphist list)

if [ -z "$clipboard_list" ]; then
    notify-send "Clipboard Manager" "Clipboard history is empty" -u normal
    exit 0
fi

# Show rofi menu
selected=$(echo "$clipboard_list" | rofi -dmenu \
    -i \
    -p "Clipboard" \
    -display-columns 2 \
    -theme "$ROFI_THEME"
    )

# If something was selected, copy it to clipboard
if [ -n "$selected" ]; then
    # Decode and copy to clipboard
    echo "$selected" | cliphist decode | wl-copy
    notify-send "Clipboard Manager" "Copied to clipboard" -u low
fi
