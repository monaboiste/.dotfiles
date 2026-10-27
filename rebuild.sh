#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  exec darwin-rebuild build --flake "$HOME/.dotfiles#macos"
elif [[ $# -eq 1 && "$1" == "--apply" ]]; then
  exec sudo darwin-rebuild switch --flake "$HOME/.dotfiles#macos"
elif [[ $# -eq 1 && "$1" == "--preview" ]]; then
  exec nix build \
    ".#darwinConfigurations.macos.config.home-manager.users.${USER}.home.activationPackage" \
    --out-link result-hm
fi

printf '%s\n' 'Usage: rebuild.sh [--apply|--preview]' >&2
exit 2
