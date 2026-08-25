#!/bin/bash

# Get user input from rofi
content=$(echo "" | rofi -dmenu -theme ~/.config/rofi/unified.rasi -p "AI" -theme-str 'listview { enabled: false; } entry { placeholder: "Ask AI..."; }')

# Make sure content is not empty
if [ -z "$content" ]; then
  echo "No input provided. Exiting..."
  exit 1
fi


# Start Response Display
rm -f /tmp/askai-resp.md
kitty --detach --class "askai" --override="font_size 14" ~/.config/scripts/rofi/ai/display-resp.sh

# Send request to Claude via the Claude Code CLI (-p = print mode).
# This uses the local Claude Code subscription auth, not a per-token API key.
# - </dev/null: don't let claude block waiting on stdin when spawned by niri
# - 2>&1: capture any error (e.g. auth/PATH) into the response so it's visible
ai_response=$(claude -p "$content" </dev/null 2>&1)

# Display the result in rofi
echo "$ai_response" > /tmp/askai-resp.md
