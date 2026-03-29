#!/usr/bin/env bash

# Collection here, part of url:
#   https://archive.org/details/jstor_intejethi
#   Would set COLLECTION variable to " jstor_amerjmath "
export COLLECTION=jstor_intejethi
# Write the filetype as is. Is case sensitive.
# Ignore the period before it, it is inserted later.
export FILE_TYPE=pdf

# You do not need to change anything else (unless you want to).
# ---

set -euo pipefail

mkdir -p batch1

ia search "collection:$COLLECTION" --itemlist |
  xargs -P 4 -I {} bash -c '

id="$1"
echo "Processing: $id"

# Move into batch directory
cd batch1 || exit 1

# Skip if already downloaded
if [ -d "$id" ]; then
    echo "Already downloaded: $id"
    exit 0
fi

# Get title
title=$(ia metadata "$id" | jq -r ".metadata.title // \"Unknown Title\"")

# Sanitize title
safe_title=$(echo "$title" | tr "/\\:*?\"<>|" "_" | tr -d "\n")

echo "Title: $safe_title"

# Download files 
ia download "$id" --glob="*.$FILE_TYPE" >/dev/null 2>&1

# Find files 
file=$(find "$id" -type f -iname "*.FILE_TYPE" | head -n 1 || true)

if [ -z "$file" ]; then
    echo "No $FILE_TYPE found for $id, skipping."
    exit 0
fi

# Build new filename
new_name="${safe_title} - $(basename "$file")"

# Avoid overwrite collisions
if [ -f "$new_name" ]; then
    new_name="${safe_title} - ${id}.$FILE_TYPE"
fi

# Move file
mv "$file" "$new_name"

echo "Saved: $new_name"

' _ {}
