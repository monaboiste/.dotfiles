#!/usr/bin/zsh

export NVM_DIR="${XDG_BIN_HOME:-$HOME/.nvm}/nvm"
source $(brew --prefix nvm)/nvm.sh

if ! (( $+commands[npm] )); then
  echo "Installing latest Node.js LTS via nvm..."
  nvm install --lts >/dev/null
fi
