#!/usr/bin/zsh

# Note: Disable completions - these are handled by OMZP::sdk.
#       This prevents zcompdumps generation in $ZDOTDIR.

export SDKMAN_DIR="${XDG_BIN_HOME:-$HOME/.sdkman}/sdkman"

if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  curl -s "https://get.sdkman.io" | bash

  sed -i '' 's/^sdkman_auto_complete=.*/sdkman_auto_complete=false/' "$SDKMAN_DIR/etc/config"
fi

zinit ice wait lucid
zinit snippet "$SDKMAN_DIR/bin/sdkman-init.sh"

zinit snippet OMZP::sdk
