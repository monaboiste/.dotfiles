#!/usr/bin/zsh

ZINIT_HOME="$XDG_DATA_HOME"/zinit/zinit.git

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME"/zinit.zsh

ZINIT[ZCOMPDUMP_PATH]="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
ZINIT[COMPINIT_OPTS]="-C"

zinit wait lucid for \
  atinit"zpcompinit; zicdreplay" \
  zdharma-continuum/fast-syntax-highlighting \
  Aloxaf/fzf-tab \
  blockf \
  zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd z zsh)"
