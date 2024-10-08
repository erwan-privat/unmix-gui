#!/usr/bin/env bash

umx="umx/umx"
ffmpeg="ffmpeg -v error -y"

echo ===========================
echo Args:
echo "$1"
echo "$2"
echo "$3"

src="$1"
src_ext="${src##*.}"
out_ext="$src_ext"
is_mp3=false

if [[ "$src_ext" == "mp3" ]]; then
  is_mp3=true
  out_ext=wav
  echo "Converting file '$1' to '$2'..."
  $ffmpeg -i "$1" "$2"
  src="$2"
fi

# echo "Initializing python..."
# source $conda/etc/profile.d/conda.sh
# conda activate unmix
echo "Unmixing '$src' in directory '$3'..."
$umx "$src" --outdir "$3" --audio-backend sox_io --ext ".$out_ext"

if [[ "$is_mp3" == "true" ]]; then
  for w in "$3"/{drums,bass,vocals,other}.wav; do
    $ffmpeg -i "$w" "${w%.*}.mp3"
    rm "$w"
  done
fi

echo Done in script.
