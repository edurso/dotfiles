#!/usr/bin/env bash

# exit on error
set -e
set -o pipefail

# display constant
readonly RED='\033[1;31m'
readonly BLUE='\033[1;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# directories
TMP_DIR="/tmp"
INSTALL_DIR="$HOME/bin"
CI="true"  # NOTE: set this to false if running manually

echo -e "${BLUE}fetching URL of latest version...${NC}"
ARCHIVE_URL=$(curl -s 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
ARCHIVE_FILENAME=$(basename "$ARCHIVE_URL")

echo -e "${BLUE}downloading $ARCHIVE_FILENAME...${NC}"
rm "$TMP_DIR/$ARCHIVE_FILENAME" 2>/dev/null || true
wget -q --show-progress -cO "$TMP_DIR/$ARCHIVE_FILENAME" "$ARCHIVE_URL"

echo -e "${BLUE}extracting to $INSTALL_DIR...${NC}"
mkdir -p "$INSTALL_DIR"
rm "$INSTALL_DIR/jetbrains-toolbox" 2>/dev/null || true
tar -xzf "$TMP_DIR/$ARCHIVE_FILENAME" -C "$INSTALL_DIR" --strip-components=1
rm "$TMP_DIR/$ARCHIVE_FILENAME"
chmod +x "$INSTALL_DIR/jetbrains-toolbox"


if [ -z "$CI" ]; then
	echo -e "${BLUE}running for the first time to set-up...${NC}"
	( "$INSTALL_DIR/jetbrains-toolbox" & )
	echo -e "${BLUE}Done! JetBrains Toolbox should now be running, and you can run it in terminal as jetbrains-toolbox (ensure that $INSTALL_DIR is on PATH)${NC}"
else
	echo -e "${BLUE}Done! Running in a CI -- skipped launching the AppImage.${NC}"
fi
