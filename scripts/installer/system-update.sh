#!/bin/bash

echo -e "\e[32mChecking for system updates...\e[0m\n"

# Get current flake directory
FLAKE_DIR="$HOME/nix-config"
HOSTNAME=$(hostname)

# Update flake inputs to check for updates
echo "Updating flake inputs..."
cd "$FLAKE_DIR" || exit 1
nix flake update 2>/dev/null

# Get the diff between current system and updated flake
echo "Checking for package updates..."

# Build the new system configuration without switching
nix build "$FLAKE_DIR#nixosConfigurations.$HOSTNAME.config.system.build.toplevel" --no-link 2>/dev/null

# Compare current system with new build
current_system=$(readlink -f /run/current-system)
new_system=$(nix path-info "$FLAKE_DIR#nixosConfigurations.$HOSTNAME.config.system.build.toplevel" 2>/dev/null)

if [[ "$current_system" == "$new_system" ]]; then
    echo -e "\e[32mSystem is up to date!\e[0m"
    exit 0
fi

# Get list of package changes
echo "Calculating package differences..."
updates=$(nix store diff-closures "$current_system" "$new_system" 2>/dev/null | grep -E "^[+-]" | sed 's/^[+-] //')

if [[ -z "$updates" ]]; then
    echo -e "\e[32m No package changes detected!\e[0m"
    exit 0
fi

update_count=$(echo "$updates" | wc -l)

# Display updates with fzf
fzf_args=(
    --preview 'echo {}'
    --preview-label="Package changes - Press ENTER to rebuild system"
    --preview-label-pos='bottom'
    --preview-window 'right:60%:wrap'
    --bind 'alt-p:toggle-preview'
    --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
    --bind 'alt-k:preview-up,alt-j:preview-down'
    --header="$update_count package(s) will change"
    --color 'pointer:blue,marker:blue'
    --no-multi
)

echo -e "$updates" | fzf "${fzf_args[@]}" > /dev/null

# Check if user pressed enter (fzf returns 0 on selection)
if [[ $? -eq 0 ]]; then
    echo -e "\n\e[33mStarting system rebuild...\e[0m\n"
    
    # Rebuild and switch to new system
    sudo nixos-rebuild switch --flake "$FLAKE_DIR#$HOSTNAME"
    
    if [[ $? -eq 0 ]]; then
        echo -e "\n\e[32mSystem rebuild completed!\e[0m"
    else
        echo -e "\n\e[31mSystem rebuild failed!\e[0m"
        exit 1
    fi
else
    echo -e "\n\e[31mRebuild cancelled.\e[0m"
fi
