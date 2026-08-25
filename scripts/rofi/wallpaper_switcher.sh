#!/usr/bin/env bash

# Wallpapers Path
wallpaperDir="$HOME/Pictures/wallpaper"
themesDir="$HOME/.config/rofi"

# Retrieve image files as a list
PICS=($(find -L "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | shuf ))

# Use date variable to increase randomness for the random button calculation
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"
randomChoice="[${#PICS[@]}] Random"

# Rofi command
rofiCommand="rofi -show -dmenu -theme ${themesDir}/wallpaper.rasi --class 'wallpaper'"

# awww transition config
FPS=60
TYPE="none"
DURATION=1
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

# niri  -> Noctalia 
# Hyprland -> awww
executeCommand() {

  if [[ "$XDG_CURRENT_DESKTOP" == *niri* ]] || pgrep -x niri >/dev/null; then
    noctalia msg wallpaper-set "$1"
  elif command -v awww &>/dev/null; then
    awww img "$1" ${SWWW_PARAMS}
  elif command -v swaybg &>/dev/null; then
    swaybg -i "$1" &
  else
    echo "No supported wallpaper manager found."
    exit 1
  fi

  ln -sf "$1" "$HOME/.current_wallpaper"
}

# Show the images
menu() {
  printf "%s\n" "$randomChoice"

  for i in "${!PICS[@]}"; do
   
    # If not *.gif, display
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "%s\x00icon\x1f%s\n" "$(basename "${PICS[$i]}" | cut -d. -f1)" "${PICS[$i]}"
    else
    # Displaying .gif to indicate animated images
      printf "%s\n" "$(basename "${PICS[$i]}")"
    fi
  done
}

main() {
  choice=$(menu | ${rofiCommand})

  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Random choice case
  if [ "$choice" = "$randomChoice" ]; then
    executeCommand "${randomPicture}"
    return 0
  fi

  # Find the selected file
  for file in "${PICS[@]}"; do
  # Getting the file
    if [[ "$(basename "$file" | cut -d. -f1)" = "$choice" ]]; then
      selectedFile="$file"
      break
    fi
  done

  # Check the file and execute
  if [[ -n "$selectedFile" ]]; then
    executeCommand "${selectedFile}"
    return 0
  else
    echo "Image not found."
    exit 1
  fi

}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main
