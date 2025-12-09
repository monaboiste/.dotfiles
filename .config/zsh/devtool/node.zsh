#!/usr/bin/zsh

export NVM_DIR="${XDG_BIN_HOME:-$HOME/.nvm}/nvm"

_load_nvm() {
  unset -f nvm npm npx node _load_nvm
  source "$(brew --prefix nvm)/nvm.sh"
}

nvm()  { _load_nvm; nvm  "$@"; }
npm()  { _load_nvm; npm  "$@"; }
npx()  { _load_nvm; npx  "$@"; }
node() { _load_nvm; node "$@"; }

local node_versions=("$NVM_DIR"/versions/node/*(N))
if (( ${#node_versions} == 0 )); then
  echo "Installing latest Node.js LTS via nvm..."
  _load_nvm
  nvm install --lts >/dev/null
fi
