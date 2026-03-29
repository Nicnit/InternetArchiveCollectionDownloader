#!/usr/bin/env bash

# Collection here, part of url:
#   https://archive.org/details/jstor_intejethi
#   Would set COLLECTION variable to " jstor_amerjmath "
export COLLECTION=jstor_intejethi

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

# Download PDFs
ia download "$id" --glob="*.pdf" >/dev/null 2>&1

# Find PDF
file=$(find "$id" -type f -iname "*.pdf" | head -n 1 || true)

if [ -z "$file" ]; then
    echo "No PDF found for $id, skipping."
    exit 0
fi

# Build new filename
new_name="${safe_title} - $(basename "$file")"

# Avoid overwrite collisions
if [ -f "$new_name" ]; then
    new_name="${safe_title} - ${id}.pdf"
fi

# Move file
mv "$file" "$new_name"

echo "Saved: $new_name"

' _ {}
