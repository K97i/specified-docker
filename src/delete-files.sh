#!/usr/bin/env bash

# https://stackoverflow.com/a/1482133
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

cd "$SCRIPT_DIR" || exit 1

HELD_FILES_LIST="$SCRIPT_DIR/config/held_files"
FILES_DIR="$SCRIPT_DIR/files"

touch "$HELD_FILES_LIST"

find "$FILES_DIR" -mindepth 1 -mtime +0 -type f | while IFS= read -r fileName; do 
  if grep -Fxq "$fileName" "$HELD_FILES_LIST"; then
    echo "$fileName held"
  else
    rm -- "$fileName"
    echo "$fileName deleted"
  fi
done