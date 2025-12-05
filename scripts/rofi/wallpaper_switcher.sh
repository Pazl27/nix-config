#!/usr/bin/env bash

# Wallpapers Path
wallpaperDir="$HOME/Pictures/wallpaper"
themesDir="$HOME/.config/rofi"

# Transition config
FPS=60
TYPE="none"
DURATION=1
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files as a list
PICS=($(find -L "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | shuf ))

# Use date variable to increase randomness for the random button calculation
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"
randomChoice="[${#PICS[@]}] Random"

# Rofi command
rofiCommand="rofi -show -dmenu -theme ${themesDir}/wallpaper.rasi --class 'wallpaper'"

# Execute command according the wallpaper manager
executeCommand() {

  if command -v swww &>/dev/null; then
    swww img "$1" ${SWWW_PARAMS}

  elif command -v swaybg &>/dev/null; then
    swaybg -i "$1" &
   
  else
    echo "Neither swww nor swaybg are installed."
    exit 1
  fi

  ln -sf "$1" "$HOME/.current_wallpaper"
}

# Show the images
menu() {
  # Der Random-Knopf wird ZUERST ausgegeben, bleibt also oben
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

# If swww exists, start it
if command -v swww &>/dev/null; then
  swww query || swww init
fi

# Execution
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

main
