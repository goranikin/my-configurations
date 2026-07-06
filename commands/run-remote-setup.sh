#!/usr/bin/env bash
# Run setup.sh on a remote server over SSH.
#
# Usage:
#   SERVER=user@host ./commands/run-remote-setup.sh
#   SERVER=user@host ./commands/run-remote-setup.sh --push
#   SERVER=user@host ./commands/run-remote-setup.sh --only base zsh

set -euo pipefail

# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

push_first=0
setup_args=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --push)
      push_first=1
      shift
      ;;
    *)
      setup_args+=("$1")
      shift
      ;;
  esac
done

if [[ "${push_first}" -eq 1 ]]; then
  "${COMMANDS_DIR}/push-to-server.sh"
fi

require_server

remote_env="$(remote_setup_env | paste -sd' ' -)"
remote_cmd="cd ${REMOTE_DIR} && sudo env ${remote_env} ./setup.sh"

if [[ ${#setup_args[@]} -gt 0 ]]; then
  remote_cmd+=" $(printf '%q ' "${setup_args[@]}")"
fi

echo "==> Running setup on ${SERVER}"
ssh_cmd "bash -lc $(printf '%q' "${remote_cmd}")"
