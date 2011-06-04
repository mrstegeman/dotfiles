#!/bin/sh

. "$UZBL_UTIL_DIR/uzbl-dir.sh"

>> "$UZBL_HISTORY_FILE" || exit 1

# remove duplicate entries
trans=$(echo "$UZBL_URI" | sed 's_\/_\\\/_g')
sed -i "/$trans /d" "$UZBL_HISTORY_FILE"

# now add the link to the history file
echo "$( date +'%Y-%m-%d %H:%M:%S' ) $UZBL_URI $UZBL_TITLE" >> "$UZBL_HISTORY_FILE"
