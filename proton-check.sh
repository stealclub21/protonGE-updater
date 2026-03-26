#!/bin/bash

LATEST_VERSION=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | jq -r '.tag_name // empty')
LOCAL_PATH="$HOME/.steam/root/compatibilitytools.d"
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | jq -r '.assets[] | select(.name | endswith(".tar.gz")) | .browser_download_url')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch Proton version. URL might be changed."
    exit 1
fi


if [ ! -d "$LOCAL_PATH/$LATEST_VERSION" ]; then
    echo "---> Update available" "New proton version: $LATEST_VERSION <---"
    echo "Would you like to update? y/n "

    while true; do
    read input
    case "$input" in
        [Yy]* ) input="y"; break;;
        [Nn]* ) input="n"; break;;
        * ) echo "Please type 'y' for yes or 'n' for no.";;
    esac
    done

    if [[ "$input" == y ]]; then
    echo "Starting update..."
    curl -L "$DOWNLOAD_URL" | tar -xzf - -C "$LOCAL_PATH"
    echo "Done! Please restart Steam to see the new version"
    else
        echo "Update cancelled."
    fi

else
    echo "Your proton version is up to date!"
fi

