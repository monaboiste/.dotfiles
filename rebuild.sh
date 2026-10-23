#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  exec darwin-rebuild build --flake "$HOME/.dotfiles#macos"
elif [[ $# -eq 1 && "$1" == "--apply" ]]; then
  exec sudo darwin-rebuild switch --flake "$HOME/.dotfiles#macos"
fi

printf '%s\n' 'Usage: rebuild.sh [--apply]' >&2
exit 2
