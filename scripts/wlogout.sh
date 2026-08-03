#!/usr/bin/env bash

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

resolution=""
if [ -n "$NIRI_SOCKET" ] && command -v niri > /dev/null; then
    # niri: .logical.height is already logical (scale-adjusted)
    resolution=$(niri msg --json focused-output | jq -r '.logical.height')
elif [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] && command -v hyprctl > /dev/null; then
    # hyprland: divide physical height by scale to get the logical height
    resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' | awk -F'.' '{print $1}')
fi

if [ -z "$resolution" ] || [ "$resolution" = "null" ]; then
    resolution=1080
fi

margin_percentage=0.35
top_margin=$(awk "BEGIN {printf \"%.0f\", $resolution * $margin_percentage}")
bottom_margin=$top_margin

wlogout -C $HOME/.config/wlogout/style.css \
    -l $HOME/.config/wlogout/layout \
    --protocol layer-shell \
    -b 5 \
    -T $top_margin \
    -B $bottom_margin &
