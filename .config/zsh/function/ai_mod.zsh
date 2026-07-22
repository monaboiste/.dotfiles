#!/bin/zsh
#
# Lightweight CLI wrapper around
# OpenCode for quick terminal/scripting assistance.
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
  mod --commit [guidance]
  mod --commit --resume <session_id> [guidance]

Options:
  --commit                Propose commit groups and messages for the current repository.
  --resume <session_id>   Resume a previous conversation.
  --help                  Show this help message.

Description:
  A thin wrapper around OpenCode for quick terminal and scripting assistance.
  Uses North Mini Code Free with reasoning disabled for shell commands.
  Commit mode loads the OpenCode commit skill to propose commit groups and messages.

  Always prints:
    1. The suggested command/answer.
    2. The session ID for follow-up questions.

Examples:
  mod "list current directory"
  mod "find all .log files older than 7 days"
  mod --resume abc123 "now delete them"
  mod --commit
  mod --commit "emphasize the OpenCode migration"
EOF
}

#######################################
# Main entry point.
# Globals:
#   None
# Arguments:
#   --commit               Propose commit messages for the current repository.
#   --resume <session_id>  Resume a previous session.
#   --help                 Show usage.
#   <prompt>               The question, request, or optional commit guidance.
# Outputs:
#   Suggested command and session ID.
# Returns:
#   0 on success, 1 on failure.
#######################################
mod() {
  local session_id=""
  local prompt=""
  local mode="shell"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --help)
      _mod::help
      return 0
      ;;
    --commit)
      mode="commit"
      shift
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

  if [[ -z "${prompt}" && "${mode}" == "shell" ]]; then
    printf "[ERROR] No prompt provided.\n" >&2
    _mod::help
    return 1
  fi

  local system_prompt
  local request
  local variant="none"
  local permission='"deny"'

  if [[ "${mode}" == "commit" ]]; then
    local -r commit_skill="${XDG_CONFIG_HOME:-${HOME}/.config}/opencode/skills/commit/SKILL.md"

    if [[ ! -r "${commit_skill}" ]]; then
      printf "[ERROR] OpenCode commit skill not found: %s\n" "${commit_skill}" >&2
      return 1
    fi

    [[ -n "${prompt}" ]] || prompt="Propose commit messages for the current changes."

    system_prompt="You are a concise Git commit message assistant. \
Load the commit skill using the skill tool and follow its instructions to inspect the repository. \
Complete only the proposal phase: show logical file groups and commit messages, then stop. \
Never stage files or create commits. \
Apply any additional guidance from the user."
    variant="high"
    request="${prompt}"
    permission='{
      "*": "deny",
      "skill": {
        "*": "deny",
        "commit": "allow"
      },
      "bash": {
        "*": "deny",
        "git status -u": "allow",
        "git diff": "allow",
        "git log -5 --oneline": "allow"
      }
    }'
  else
    system_prompt="You are a concise terminal assistant. \
The user's shell is zsh on macOS. \
Respond ONLY with the exact command(s) needed - no explanation, no markdown fences, no commentary. \
If multiple commands are needed, put each on its own line. \
If the request is ambiguous, pick the most common interpretation."
    request="${prompt}"
  fi

  local opencode_config
  opencode_config="$(jq -cn --arg prompt "${system_prompt}" --argjson permission "${permission}" '{
    agent: {
      mod: {
        description: "Suggests concise shell commands or Git commit messages without executing tools.",
        mode: "primary",
        prompt: $prompt,
        permission: $permission
      }
    }
  }')"

  if [[ $? -ne 0 || -z "${opencode_config}" ]]; then
    printf "[ERROR] Could not prepare OpenCode configuration.\n" >&2
    return 1
  fi

  local -a cmd=(
    env
    "OPENCODE_CONFIG_CONTENT=${opencode_config}"
    opencode
    run
    --pure
    --model opencode/north-mini-code-free
    --variant "${variant}"
    --agent mod
    --format json
  )

  if [[ -n "${session_id}" ]]; then
    cmd+=(--session "${session_id}")
  fi

  local raw_output
  raw_output="$(printf '%s' "${request}" | "${cmd[@]}" 2>/dev/null)"

  if [[ $? -ne 0 || -z "${raw_output}" ]]; then
    printf "[ERROR] OpenCode request failed.\n" >&2
    return 1
  fi

  local result
  local sid
  result="$(printf '%s' "${raw_output}" | jq -rs '[.[] | select(.type == "text") | .part.text] | join("\n")')"
  sid="$(printf '%s' "${raw_output}" | jq -rs 'first(.[] | .sessionID? // empty) // empty')"

  if [[ -z "${result}" ]]; then
    printf "[ERROR] Could not parse response.\n" >&2
    return 1
  fi

  printf "%s\n" "${result}"
  printf "\n\033[2msession: %s\033[0m\n" "${sid}"
}
