#!/usr/bin/zsh

export SDKMAN_DIR="${XDG_BIN_HOME:-$HOME/.sdkman}/sdkman"
if [[ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
  curl -s "https://get.sdkman.io" | bash
fi
source "$SDKMAN_DIR/bin/sdkman-init.sh"
