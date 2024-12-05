#!/bin/bash

# Check if target folder is specified
if [[ -z $1 ]]; then
    echo "Usage: $0 /path/to/backup/folder"
    exit 1
fi

# Set target folder from the command-line argument
TARGET_FOLDER="$1"

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Please install yay first."
    exit 1
fi

# Check for updates and get the list of packages
echo "Checking for AUR package updates..."
UPDATE_LIST=$(yay -Qua --aur | awk '{print $1}')

if [[ -z $UPDATE_LIST ]]; then
    echo "No AUR package updates found."
else
    echo "Updating AUR packages..."
    yay -Syu --aur
fi

# Ensure target folder exists
mkdir -p "$TARGET_FOLDER"

# Process AUR cache
echo "Processing AUR package cache..."
YAY_CACHE="$HOME/.cache/yay"
for PACKAGE_DIR in "$YAY_CACHE"/*; do
    if [[ -d $PACKAGE_DIR ]]; then
        PACKAGE_NAME=$(basename "$PACKAGE_DIR")
        PACKAGE_FILE=$(find "$PACKAGE_DIR" -type f -name "*.tar.zst" | sort -V | tail -n 1)
        
        if [[ -f $PACKAGE_FILE ]]; then
            TARGET_FILE="$TARGET_FOLDER/$(basename "$PACKAGE_FILE")"
            
            # Remove older versions of the package from the target folder
            find "$TARGET_FOLDER" -type f -name "${PACKAGE_NAME}-*.tar.zst" ! -name "$(basename "$PACKAGE_FILE")" -exec rm {} \;
            
            # Copy the latest package file
            echo "Copying $PACKAGE_FILE to $TARGET_FOLDER"
            cp "$PACKAGE_FILE" "$TARGET_FOLDER"
        fi
    fi
done

echo "Backup process completed."

