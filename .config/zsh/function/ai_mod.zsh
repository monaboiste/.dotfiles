#!/bin/zsh
#
# Lightweight CLI wrapper around Claude Code for quick terminal/scripting assistance.
#

#######################################
# Print usage information.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes usage text to stdout.
#######################################
_mod::help() {
  cat <<'EOF'
Usage:
  mod <prompt>
  mod --resume <session_id> <prompt>

Options:
  --resume <session_id>   Resume a previous conversation.
  --help                  Show this help message.

Description:
  A thin wrapper around Claude Code for quick terminal and scripting assistance.
  Uses the cheapest model (haiku) with a system prompt tuned for shell commands.

  Always prints:
    1. The suggested command/answer.
    2. The session ID for follow-up questions.

Examples:
  mod "list current directory"
  mod "find all .log files older than 7 days"
  mod --resume abc123 "now delete them"
EOF
}

#######################################
# Main entry point.
# Globals:
#   None
# Arguments:
#   --resume <session_id>  Resume a previous session.
#   --help                 Show usage.
#   <prompt>               The question or request.
# Outputs:
#   Suggested command and session ID.
# Returns:
#   0 on success, 1 on failure.
#######################################
mod() {
  local session_id=""
  local prompt=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --help)
      _mod::help
      return 0
      ;;
    --resume)
      if [[ -z "${2:-}" ]]; then
        printf "[ERROR] --resume requires a session ID.\n" >&2
        return 1
      fi
      session_id="$2"
      shift 2
      ;;
    *)
      prompt="$*"
      break
      ;;
    esac
  done

  if [[ -z "${prompt}" ]]; then
    printf "[ERROR] No prompt provided.\n" >&2
    _mod::help
    return 1
  fi

  local -r system_prompt="You are a concise terminal assistant. \
The user's shell is zsh on macOS. \
Respond ONLY with the exact command(s) needed — no explanation, no markdown fences, no commentary. \
If multiple commands are needed, put each on its own line. \
If the request is ambiguous, pick the most common interpretation."

  local -a cmd=(
    claude
    --print
    --model haiku
    --output-format json
    --system-prompt "${system_prompt}"
  )

  if [[ -n "${session_id}" ]]; then
    cmd+=(--resume "${session_id}")
  fi

  cmd+=("${prompt}")

  local raw_output
  raw_output="$("${cmd[@]}" 2>/dev/null)"

  if [[ $? -ne 0 || -z "${raw_output}" ]]; then
    printf "[ERROR] Claude request failed.\n" >&2
    return 1
  fi

  local result
  local sid
  result="$(printf '%s' "${raw_output}" | jq -r '.result // empty')"
  sid="$(printf '%s' "${raw_output}" | jq -r '.session_id // empty')"

  if [[ -z "${result}" ]]; then
    printf "[ERROR] Could not parse response.\n" >&2
    return 1
  fi

  printf "%s\n" "${result}"
  printf "\n\033[2msession: %s\033[0m\n" "${sid}"
}
