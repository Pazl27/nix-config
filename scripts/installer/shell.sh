#!/usr/bin/env bash

GREEN='\e[32m'
BLUE='\e[34m'
YELLOW='\e[33m'
RED='\e[31m'
RESET='\e[0m'

echo -e "${GREEN}NixOS Package Search & Shell${RESET}\n"

# Check dependencies
for cmd in fzf; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}Error: '$cmd' is not installed.${RESET}"
        read -p "Press Enter to continue..."
        exit 1
    fi
done

# Cache file
CACHE_FILE="$HOME/.cache/nix-packages-list.txt"
CACHE_AGE=86400  # 24 hours

# Function to update cache
update_cache() {
    echo -e "${BLUE}Fetching packages from nixpkgs...${RESET}"
    echo -e "${YELLOW}(This takes 2-3 minutes on first run)${RESET}\n"
    
    mkdir -p "$(dirname "$CACHE_FILE")"
    
    echo -e "${BLUE}Building package list...${RESET}"
    nix-env -qaP --description 2>/dev/null | \
        awk -F' ' '{
            # Extract package attribute path (first field)
            pkg = $1;
            
            # Remove nixpkgs. or nixos. prefix
            sub(/^nixpkgs\./, "", pkg);
            sub(/^nixos\./, "", pkg);
            
            # Get description (everything after first field)
            $1 = "";
            desc = $0;
            gsub(/^[ \t]+/, "", desc);
            if (desc == "") desc = "No description";
            
            print pkg " - " desc
        }' | sort -u > "$CACHE_FILE.tmp"
    
    # Check if we got results
    if [[ -s "$CACHE_FILE.tmp" ]]; then
        mv "$CACHE_FILE.tmp" "$CACHE_FILE"
        line_count=$(wc -l < "$CACHE_FILE")
        echo -e "${GREEN}✓ Found $line_count packages${RESET}\n"
        return 0
    else
        rm -f "$CACHE_FILE.tmp"
        echo -e "${RED}✗ Failed to fetch packages${RESET}"
        return 1
    fi
}

# Check if cache exists and is valid
need_update=false

if [[ ! -f "$CACHE_FILE" ]]; then
    echo -e "${YELLOW}No cache found. Creating...${RESET}\n"
    need_update=true
elif [[ ! -s "$CACHE_FILE" ]]; then
    echo -e "${YELLOW}Cache is empty. Recreating...${RESET}\n"
    need_update=true
else
    # Check cache age
    if [[ "$(uname)" == "Darwin" ]]; then
        cache_age=$(($(date +%s) - $(stat -f %m "$CACHE_FILE")))
    else
        cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
    fi
    
    if [[ $cache_age -gt $CACHE_AGE ]]; then
        line_count=$(wc -l < "$CACHE_FILE")
        echo -e "${YELLOW}Cache is old (24h+, $line_count packages). Update? (y/n)${RESET}"
        read -p "> " -t 10 update_confirm || update_confirm="n"
        
        if [[ $update_confirm == "y" || $update_confirm == "Y" ]]; then
            need_update=true
        fi
    fi
fi

# Update cache if needed
if [[ $need_update == true ]]; then
    update_cache || exit 1
else
    line_count=$(wc -l < "$CACHE_FILE")
    echo -e "${GREEN}Using cached packages ($line_count packages)${RESET}\n"
fi

# Verify cache has content
if [[ ! -s "$CACHE_FILE" ]]; then
    echo -e "${RED}Error: Package cache is empty${RESET}"
    read -p "Press Enter to continue..."
    exit 1
fi

# Multi-select with fzf
echo -e "${GREEN}Select packages:${RESET}"
echo -e "${BLUE}TAB${RESET} = select | ${BLUE}CTRL-A${RESET} = all | ${BLUE}ENTER${RESET} = confirm\n"

selected=$(cat "$CACHE_FILE" | \
    fzf --multi \
        --height=90% \
        --layout=reverse \
        --border=rounded \
        --prompt="Search> " \
        --preview='echo {} | sed "s/^[^ ]* - //"' \
        --preview-window=up:3:wrap \
        --bind='ctrl-a:select-all,ctrl-d:deselect-all' \
        --header='↑↓: navigate | TAB: select | CTRL-A: select all | ENTER: confirm')

# Exit if nothing selected
if [[ -z "$selected" ]]; then
    echo -e "\n${YELLOW}No packages selected.${RESET}"
    read -p "Press Enter to continue..."
    exit 0
fi

# Extract package names (before " - ")
# And ensure no nixos./nixpkgs. prefix remains
packages=$(echo "$selected" | \
    sed 's/ - .*//' | \
    sed 's/^nixpkgs\.//' | \
    sed 's/^nixos\.//' | \
    tr '\n' ' ')

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}Selected packages:${RESET}"
echo -e "${BLUE}$packages${RESET}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

# Build nix-shell command
nix_cmd="nix-shell -p $packages"
echo -e "${YELLOW}Command:${RESET} ${BLUE}$nix_cmd${RESET}\n"

# Ask confirmation
echo -e "${YELLOW}Launch nix-shell? (y/n)${RESET}"
read -p "> " confirm

if [[ $confirm == "y" || $confirm == "Y" ]]; then
    echo -e "\n${GREEN}Launching nix-shell...${RESET}\n"
    exec $nix_cmd
else
    echo -e "\n${YELLOW}Cancelled. Copy command:${RESET}"
    echo -e "${BLUE}$nix_cmd${RESET}\n"
    read -p "Press Enter to continue..."
fi
