#!/bin/bash

add_src() {
  outvar="$1"
  shift 1

  content="$content
  # nix-prefetch-github "$*" --nix
  $outvar = fetchFromGitHub {
$(nix-prefetch-github "$@" --nix | grep " = " | grep -v "nixpkgs")
  };"
}

add_src hubs mozilla hubs
add_src reticulum mozilla reticulum
add_src spoke mozilla Spoke
add_src yt-dl-server mozillareality youtube-dl-api-server
add_src dialog mozilla dialog

echo "{ fetchFromGitHub }: {$content
}" > src.nix
