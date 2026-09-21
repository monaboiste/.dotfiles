#!/bin/zsh
#
# Rotate AWS temporary credentials using AWS SSO.
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
_aws::help() {
  cat <<'EOF'
Usage:
  aws::rotate_keys [--profile <profile>]

Options:
  --profile <profile>   AWS SSO profile name to use.
                        Default: playground
  --help                Show this help message.

Description:
  Rotates AWS temporary credentials using AWS SSO.
  Automatically refreshes short-lived AWS access keys for a given SSO profile.

Examples:
  aws::rotate_keys
  aws::rotate_keys --profile playground
  aws::rotate_keys --profile myprofile
  aws::rotate_keys --help

Requirements:

  1. Dependencies
     - aws
     - jq

  2. AWS SSO configuration
     Example ~/.aws/config:

     [profile playground]
     sso_session = company
     sso_account_id = 0001
     sso_role_name = teamname_playground_rw
     region = eu-west-1
     output = json

     [sso-session company]
     sso_start_url = https://company.awsapps.com/start
     sso_region = us-east-1
     sso_registration_scopes = sso:account:access
EOF
}

#######################################
# Verify that required CLI tools are installed.
# Arguments:
#   Tool names to check.
# Returns:
#   0 if all tools are found, 1 otherwise.
#######################################
_aws::check_dependencies() {
  local tool
  for tool in "$@"; do
    if ! command -v "${tool}" &>/dev/null; then
      printf "[ERROR] '%s' is not installed. Please install it.\n" \
        "${tool}" >&2
      return 1
    fi
  done
  return 0
}

#######################################
# Rotate AWS keys for a given SSO profile.
# Globals:
#   HOME
#   AWS_PROFILE
# Arguments:
#   --profile <profile>  AWS SSO profile (default: playground).
#   --help               Show usage.
# Returns:
#   0 on success, 1 on failure.
#######################################
aws::rotate_keys() {
  local profile="playground"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    --help)
      _aws::help
      return 0
      ;;
    --profile)
      if [[ -z "${2:-}" ]]; then
        printf "[ERROR] --profile requires a value.\n" >&2
        return 1
      fi
      profile="$2"
      shift 2
      ;;
    *)
      printf "[ERROR] Unknown option: %s\n" "$1" >&2
      printf "Run with --help for usage.\n" >&2
      return 1
      ;;
    esac
  done

  if ! _aws::check_dependencies aws jq; then
    return 1
  fi

  local -r cred_file="${HOME}/.aws/credentials"

  printf "=> Running AWS Key Rotation for profile: %s\n" "${profile}"

  if aws sts get-caller-identity --profile "${profile}" >/dev/null 2>&1; then
    printf "[OK] Already logged in to SSO.\n"
  else
    printf "[WARN] SSO session expired or missing.\n"
    printf "==> Logging in to '%s'...\n" "${profile}"

    if ! aws sso login --profile "${profile}"; then
      printf "[ERROR] Login failed.\n" >&2
      return 1
    fi
    printf "[OK] Login successful.\n"
  fi

  printf "=> Fetching temporary role credentials...\n"

  local creds_json
  creds_json="$(aws configure export-credentials \
    --profile "${profile}" 2>/dev/null)"

  if [[ -z "${creds_json}" ]]; then
    printf "[ERROR] Failed to retrieve credentials.\n" >&2
    return 1
  fi

  local -r key_id="$(echo "${creds_json}" | jq -r '.AccessKeyId')"
  local -r secret_key="$(echo "${creds_json}" | jq -r '.SecretAccessKey')"
  local -r session_token="$(echo "${creds_json}" | jq -r '.SessionToken')"

  printf "=> Saving credentials to [default] profile in %s...\n" \
    "${cred_file}"

  aws configure set aws_access_key_id "${key_id}" --profile default
  aws configure set aws_secret_access_key "${secret_key}" --profile default
  aws configure set aws_session_token "${session_token}" --profile default

  printf "=> Saving credentials to [%s] profile in %s...\n" \
    "${profile}" "${cred_file}"

  aws configure set aws_access_key_id "${key_id}" --profile "${profile}"
  aws configure set aws_secret_access_key "${secret_key}" --profile "${profile}"
  aws configure set aws_session_token "${session_token}" --profile "${profile}"

  export AWS_PROFILE="${profile}"

  printf "----------------------------------------\n"
  printf "[SUCCESS]\n"
  printf "Access Key ID: %s\n" "${key_id}"
  printf "[default] and [%s] profile updated.\n" "${profile}"
  printf "----------------------------------------\n"
}
