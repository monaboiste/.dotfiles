#!/usr/bin/zsh

# NOTE: use `type <alias>` to see what is assigned to an alias/fn/builtin/keyword
#       the use of `type` doesn't always work in ZSH so use `whence -c` instead.
#       Alternatively, use `alias <name>` function with no arguments.
#

alias python3='python3.14'
alias n='nvim'
alias ta='tmux new-session -A -D -s main'
alias idea='open -n -g -a "IntelliJ IDEA.app" --args'

alias ls='eza'
alias ll='eza -lg --icons'
alias la='eza -lag --icons'
alias lt='eza -lgT --icons'
alias lt1='eza -gT --icons --level=1'
alias lt2='eza -gT --icons --level=2'
alias lt3='eza -gT --icons --level=3'
alias lta='eza -agT --icons'
alias lta1='eza -agT --icons --level=1'
alias lta2='eza -agT --icons --level=2'
alias lta3='eza -agT --icons --level=3'

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Helpers
zinit::update() {
  echo "🔄 Updating Zinit and plugins..."
  zinit self-update && zinit update --all
  echo "✅ All Zinit plugins updated!"
}

help::vim_tips() {
cat <<'EOF'
x Multiline edit:
  - ctrl+v (visual mode)
  - select, I to type or c to delete, type your word (only first line will be visible)
  - double press esc
x Jump:
  - by a paragraph: shift+[ or shift+]
  - to the next parenthesis: %
  - to char: f
  - scroll by half page: ctrl+d and ctrl+u
x Fold:
  - open/close: za
  - close all: zM
  - open all: zR
x Navigation:
  - { and }
  - jump to matching pairs of (), [], {}
x Actions:
  - select entire line: V
  - indent selection: =
  - find and replace: v to select, :s/old_text/new_text/g
  - with relativenumber:
      d5j   delete next 5 lines
      y3k   yank 3 lines up
      >4j   indent next 4 lines
  - select last highlighted text: gv
  - black hole register: "_dd, "_yy
x Registers:
  - Show registers: "
  - Copy to register: +yy
  - Paste from register "(1-7)p
EOF
}

help::yazi_tips() {
cat <<'EOF'
x Search:
  - Search in current directory: /
  - Fuzzy find: Z
  - Filter files: f
  - Search for files: s
  - Search content: S
x Navigation:
  - Base navigating: g (e.g. gh or gc)
  - New Tab: t
  - Move between tabs: [ or ] or <N>
  - Close tab: <ctrl>+c
x Display:
  - Sort files: ,
  - Show directory size: ,s
  - Show meta: <tab>
  - Show hidden: .
  - Show tasks: w
x Actions:
  - Yank file: y
  - Cut file: x
  - Rename file: r
  - Copy filename/path/directory: c
  - Multiselect (Bulk edit): <space>
  - Reveal/Open: O
  - Run command: ;, : (block)
  - Select (tmux): enter copy mode - <prefix>+[
EOF
}

help::keychain() {
cat <<'EOF'
x Add secret: security add-generic-password -a $USER -s "MY_SECRET" -w "supersecret"
x Retrieve secret: export SECRET_KEY=$(security find-generic-password -s "MY_SECRET" -w)
EOF
}

help::zsh_perf() {
cat <<'EOF'
zmodload zsh/zprof
#... .zshrc
zprof

time zsh -i -c exit
EOF
}

help::misc() {
cat <<'EOF'
x Connect to docker host: host,port, protocol must be specified
  mysql --user=root --password=mysql --port=3306 --host=localhost --protocol=tcp -e "show databases;"
x Replace recursively in files (git)
  git grep -lz "lombok.extern.log4j.Log4j2" | xargs -0 sed -i "" -e "s/lombok.extern.log4j.Log4j2/lombok.extern.slf4j.Slf4j/g"
x Find largest files
  find carriers/ -name "*.json" -exec ls -lh {} \; -maxdepth 5 | sort -n | head -n 10
x Compare two files
  comm -2 -3 file1 file2
x DNS
  - view cached records: dscacheutil -q host -a name google.com
  - flush: sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
x Analyes details of the request, including times
  httpstat https://example.com/api/v1/resource
x SSH
  - local port forwading: ssh -N -L localport:destination.com:destport username@bastion
  - dynamic port forwarding / ssh as SOCKS5 proxy: ssh -D localport -N username@bastion
  - jump server: ssh -J username@bastion destination.com -l destuser
x AWS S3
  - list and filter: aws s3api list-objects-v2 --bucket bucketname --prefix "dir1/dir2" --query --query "Contents[?LastModified >=$(2023-09-19)]"
x List running cron jobs
  pstree -apl $(pidof cron)
EOF
}
