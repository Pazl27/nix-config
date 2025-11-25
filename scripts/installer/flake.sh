
#!/usr/bin/env bash

GREEN='\e[32m'
BLUE='\e[34m'
YELLOW='\e[33m'
RED='\e[31m'
CYAN='\e[36m'
RESET='\e[0m'

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}       NixOS Flake Update Manager       ${RESET}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

# Find flake directory
FLAKE_DIR="$HOME/nix-config"

# Check if flake directory exists
if [[ ! -d "$FLAKE_DIR" ]]; then
    echo -e "${RED}Error: Flake directory not found at $FLAKE_DIR${RESET}"
    read -p "Enter flake directory path: " FLAKE_DIR
    
    if [[ ! -d "$FLAKE_DIR" ]]; then
        echo -e "${RED}Directory not found. Exiting.${RESET}"
        read -p "Press Enter to continue..."
        exit 1
    fi
fi

cd "$FLAKE_DIR" || exit 1

echo -e "${BLUE}Flake directory:${RESET} ${CYAN}$FLAKE_DIR${RESET}\n"

# Check for uncommitted changes
if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    echo -e "${YELLOW}⚠ Warning: You have uncommitted changes in your flake${RESET}"
    echo -e "${YELLOW}Git status:${RESET}"
    git status --short
    echo
    echo -e "${YELLOW}Continue anyway? (y/n)${RESET}"
    read -p "> " continue_anyway
    
    if [[ $continue_anyway != "y" && $continue_anyway != "Y" ]]; then
        echo -e "${RED}Aborted.${RESET}"
        read -p "Press Enter to continue..."
        exit 0
    fi
    echo
fi

# Get current flake inputs
echo -e "${BLUE}Fetching current flake inputs...${RESET}\n"

# Create temp file for inputs
INPUTS_FILE="/tmp/flake-inputs-$$.txt"

# Parse flake.lock to get current inputs
if [[ -f "flake.lock" ]]; then
    # Get inputs from flake.lock
    nix flake metadata --json 2>/dev/null | \
        jq -r '.locks.nodes | to_entries[] | select(.key != "root") | 
        "\(.key) - \(.value.locked.rev[0:7] // "N/A") (\(.value.locked.type // "unknown"))"' \
        > "$INPUTS_FILE"
else
    echo -e "${RED}No flake.lock found!${RESET}"
    read -p "Press Enter to continue..."
    exit 1
fi

# Check if we got inputs
if [[ ! -s "$INPUTS_FILE" ]]; then
    echo -e "${RED}Could not parse flake inputs${RESET}"
    read -p "Press Enter to continue..."
    exit 1
fi

input_count=$(wc -l < "$INPUTS_FILE")
echo -e "${GREEN}Found $input_count flake inputs${RESET}\n"

# Show current inputs
echo -e "${CYAN}Current flake inputs:${RESET}"
cat "$INPUTS_FILE" | nl -w2 -s'. '
echo

# Add special options
cat "$INPUTS_FILE" >> "$INPUTS_FILE.menu"

# Select inputs with fzf
echo -e "${GREEN}Select inputs to update:${RESET}"
echo -e "${BLUE}TAB${RESET} = select multiple | ${BLUE}ENTER${RESET} = confirm\n"

selected=$(cat "$INPUTS_FILE.menu" | \
    fzf --multi \
        --height=90% \
        --layout=reverse \
        --border=rounded \
        --prompt="Select inputs> " \
        --header='TAB: select | CTRL-A: select all | ENTER: confirm' \
        --bind='ctrl-a:select-all,ctrl-d:deselect-all' \
        --preview='echo "Will update selected inputs"' \
        --preview-window=up:3:wrap)

# Clean up temp files
rm -f "$INPUTS_FILE" "$INPUTS_FILE.menu"

# Exit if nothing selected
if [[ -z "$selected" ]]; then
    echo -e "\n${YELLOW}No inputs selected.${RESET}"
    read -p "Press Enter to continue..."
    exit 0
fi

# Check if "Update ALL" was selected
if echo "$selected" | grep -q "Update ALL"; then
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}Updating ALL flake inputs...${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    
    # Update all inputs
    nix flake update
    update_status=$?
else
    # Extract input names (first word before " - ")
    inputs=$(echo "$selected" | grep -v "━" | awk '{print $1}' | tr '\n' ' ')
    
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}Selected inputs:${RESET}"
    echo -e "${BLUE}$inputs${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    
    # Update selected inputs
    for input in $inputs; do
        echo -e "${BLUE}Updating ${CYAN}$input${BLUE}...${RESET}"
        nix flake lock --update-input "$input"
    done
    update_status=$?
fi

# Check if update was successful
if [[ $update_status -eq 0 ]]; then
    echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${GREEN}Flake inputs updated successfully!${RESET}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    
    # Show what changed
    echo -e "${CYAN}Changes:${RESET}"
    git diff flake.lock | grep -E '^\+|^-' | grep -v '+++\|---' | head -20
    echo
    
    # Ask if user wants to rebuild
    echo -e "${YELLOW}Rebuild system now? (y/n)${RESET}"
    read -p "> " rebuild
    
    if [[ $rebuild == "y" || $rebuild == "Y" ]]; then
        echo -e "\n${GREEN}Starting system rebuild...${RESET}\n"
        
        # Determine hostname
        hostname=$(hostname)
        
        # Check if we're on NixOS or just Home Manager
        if [[ -f "/etc/NIXOS" ]]; then
            echo -e "${BLUE}Running: sudo nixos-rebuild switch --flake .#$hostname${RESET}\n"
            sudo nixos-rebuild switch --flake ".#$hostname"
        else
            echo -e "${BLUE}Running: home-manager switch --flake .#$hostname${RESET}\n"
            home-manager switch --flake ".#$hostname"
        fi
        
        rebuild_status=$?
        
        if [[ $rebuild_status -eq 0 ]]; then
            echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
            echo -e "${GREEN}System rebuilt successfully!${RESET}"
            echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
        else
            echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
            echo -e "${RED}Rebuild failed!${RESET}"
            echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
        fi
    else
        echo -e "\n${YELLOW}Skipping rebuild.${RESET}"
        echo -e "${CYAN}To rebuild later, run:${RESET}"
        echo -e "${BLUE}  sudo nixos-rebuild switch --flake .#$hostname${RESET}"
        echo -e "${BLUE}  # or${RESET}"
        echo -e "${BLUE}  home-manager switch --flake .#$hostname${RESET}\n"
    fi
else
    echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${RED}Update failed!${RESET}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
fi

./show-done.sh
