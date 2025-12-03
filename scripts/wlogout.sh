#!/usr/bin/env bash

# Check if wlogout is already running
if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

# Detect monitor resolution and scaling factor
resolution=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height / .scale' | awk -F'.' '{print $1}')
hypr_scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')

# Calculate top and bottom margins as percentage of screen height
# Adjust the 0.35 value (35%) to control how much space buttons take
# Higher value = more margin = smaller buttons
margin_percentage=0.35

top_margin=$(awk "BEGIN {printf \"%.0f\", $resolution * $margin_percentage * $hypr_scale}")
bottom_margin=$(awk "BEGIN {printf \"%.0f\", $resolution * $margin_percentage * $hypr_scale}")

wlogout -C $HOME/.config/wlogout/style.css \
    -l $HOME/.config/wlogout/layout \
    --protocol layer-shell \
    -b 5 \
    -T $top_margin \
    -B $bottom_margin &
