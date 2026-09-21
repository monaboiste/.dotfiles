#!/bin/zsh
#
# Guardrails for destructive file operations.
#
# Protects selected paths from accidental deletion via `rm` or `trash`.
# Add additional paths to PROTECTED_DELETE_PATHS as needed.
#

# Require an additional confirmation delay before removing files matched by `*`.
setopt RM_STAR_WAIT

typeset -ga PROTECTED_DELETE_PATHS=(
  "$HOME"
  "$HOME/Dev"
  "$HOME/.dotfiles"
  "$HOME/.agents"
  "$HOME/.claude"
  "$HOME/.pi"
)

#######################################
# Check whether a path is protected from deletion.
# Arguments:
#   $1 - Path to check.
# Returns:
#   0 if the path is protected, 1 otherwise.
#######################################
_guard::is_protected_delete_path() {
  local target="${1:A}"
  local protected

  for protected in "${PROTECTED_DELETE_PATHS[@]}"; do
    if [[ "$target" == "${protected:A}" ]]; then
      return 0
    fi
  done

  return 1
}

#######################################
# Run a deletion command unless any target path is protected.
# Arguments:
#   $1 - Command to execute.
#   $@ - Command arguments.
# Outputs:
#   Writes an error to stderr when deletion is refused.
#######################################
_guard::guarded_delete() {
  local command_name="$1"
  shift

  local arg
  local parsing_options=1

  for arg in "$@"; do
    if ((parsing_options)) && [[ "$arg" == "--" ]]; then
      parsing_options=0
      continue
    fi

    if ((parsing_options)) && [[ "$arg" == -* ]]; then
      continue
    fi

    if _guard::is_protected_delete_path "$arg"; then
      print -u2 -- "Refusing to delete protected path: ${arg:A}"
      return 1
    fi
  done

  command "$command_name" "$@"
}

rm() {
  _guard::guarded_delete rm "$@"
}

trash() {
  _guard::guarded_delete trash "$@"
}
