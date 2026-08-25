#!/usr/bin/env bash
set -eu

VAULT_NAME="notes"
VAULT_DIR="$HOME/notes"

notes="$(
    find "$VAULT_DIR" \
        \( -type d \( -name '.obsidian' -o -name '.trash' -o -name '_*' \) -prune \) -o \
        \( -type f -name '*.md' -print \) \
        2>/dev/null \
    | sed "s|^$VAULT_DIR/||; s|\.md$||" \
    | sort
)"
[ -n "$notes" ] || exit 0

chosen="$(printf '%s\n' "$notes" \
    | rofi -dmenu -i -matching fuzzy -p "Obsidian" \
        -theme "$HOME/.config/rofi/unified.rasi")"
[ -n "$chosen" ] || exit 0

# URL-encode the relative path for the obsidian:// file parameter.
encoded="$(printf '%s' "$chosen" | jq -sRr @uri)"

xdg-open "obsidian://open?vault=$VAULT_NAME&file=$encoded"
