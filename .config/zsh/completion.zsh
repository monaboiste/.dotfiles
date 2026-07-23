#!/usr/bin/zsh

# fd
zinit ice as"completion" wait lucid
zinit snippet https://raw.githubusercontent.com/sharkdp/fd/refs/heads/master/contrib/completion/_fd

# bat
zinit ice as"completion" wait lucid
zinit snippet "$XDG_CONFIG_HOME/zsh/completion/_bat"

# rg
zinit ice as"completion" wait lucid
zinit snippet "$XDG_CONFIG_HOME/zsh/completion/_rg"

# herdr
zinit ice as"completion" wait lucid
zinit snippet "$XDG_CONFIG_HOME/zsh/completion/_herdr"

# aws
zinit snippet OMZP::aws

# ssh
zinit snippet OMZP::ssh

# sdk
zinit snippet OMZP::sdk

# docker
zinit ice as"completion" wait lucid
zinit snippet OMZP::docker/completions/_docker
zinit ice as"completion" wait lucid
zinit snippet OMZP::docker-compose/_docker-compose

# Show dotfiles in completion
setopt globdots

# Completion styling
zstyle ':completion:*' cache-path "${ZINIT[ZCOMPDUMP_PATH]}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-flags --color=marker:#bac2de,pointer:#bac2de
zstyle ':fzf-tab:complete:*' fzf-preview 'ls --color -A $realpath'
zstyle ':completion::complete:*:paths' wrapper-queries 'fd --type f --hidden'
