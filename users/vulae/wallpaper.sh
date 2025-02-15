#!/usr/bin/env bash

WALLPAPER_DIR="./wallpapers"

ABS_WALLPAPER_DIR=$(realpath "$WALLPAPER_DIR")

# Select a random image file from the directory
RANDOM_WALLPAPER=$(find "$ABS_WALLPAPER_DIR" -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.jpeg \) | shuf -n 1)

if [ -n "$RANDOM_WALLPAPER" ]; then

    # Extract 2 colors from image
    COLORS=$(magick "$RANDOM_WALLPAPER" -resize 10% -kmeans 8 -format "%c" histogram:info: | sort -n -r | awk '{print $3}' | shuf | tr '\n' ' ')
    PRIMARY_COLOR=$(echo $COLORS | cut -d' ' -f1)
    SECONDARY_COLOR=$(echo $COLORS | cut -d' ' -f2)

    # Get aspect ratio
    ASPECT=$(magick "$RANDOM_WALLPAPER" -format "%[fx:w/h]" info:)

    gsettings set org.gnome.desktop.background picture-uri "file://$RANDOM_WALLPAPER"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$RANDOM_WALLPAPER"
    gsettings set org.gnome.desktop.background picture-options "scaled"
    gsettings set org.gnome.desktop.background primary-color "$PRIMARY_COLOR"
    gsettings set org.gnome.desktop.background secondary-color "$SECONDARY_COLOR"
    if (( $(echo "$ASPECT < 1.77777" | bc -l) )); then
        gsettings set org.gnome.desktop.background color-shading-type "vertical"
    else
        gsettings set org.gnome.desktop.background color-shading-type "horizontal"
    fi

    echo "Wallpaper set to: $RANDOM_WALLPAPER"
else
    echo "No image files found in the wallpapers directory."
fi

