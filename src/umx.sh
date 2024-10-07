#!/usr/bin/env bash

# conda="/home/archaoss/miniconda3/"
umx="/home/archaoss/unmix/dist/umx/umx"

echo "==========================="
echo "Args:"
echo "$1"
echo "$2"
echo "$3"

src="$1"
ext="${src##*.}"
was_wav=true

if [[ "$ext" != "wav" ]]; then
  was_wav=false
  echo "Converting file '$1' to '$2'..."
  ffmpeg -v error -y -i "$1" "$2"
  src="$2"
fi

# echo "Initializing python..."
# source $conda/etc/profile.d/conda.sh
# conda activate unmix
echo "Unmixing '$src' in directory '$3'..."
$umx "$src" --outdir "$3"

echo "Done."
