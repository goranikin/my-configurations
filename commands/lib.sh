#!/usr/bin/env bash
# Shared helpers for local → server commands.

set -euo pipefail

COMMANDS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "${COMMANDS_DIR}/.." && pwd)"
SETUP_SERVER_DIR="${SCRIPTS_ROOT}/setup-server"

REMOTE_DIR="${REMOTE_DIR:-~/setup-server}"
SSH_PORT="${SSH_PORT:-22}"

require_server() {
  if [[ -z "${SERVER:-}" ]]; then
    echo "error: SERVER is not set (e.g. export SERVER=user@host)" >&2
    exit 1
  fi
}

ssh_cmd() {
  require_server
  ssh -p "${SSH_PORT}" "${SERVER}" "$@"
}

rsync_to_server() {
  local src="$1"
  local dest="$2"
  require_server
  rsync -avz --delete -e "ssh -p ${SSH_PORT}" "${src}" "${SERVER}:${dest}"
}

rsync_from_server() {
  local src="$1"
  local dest="$2"
  require_server
  rsync -avz -e "ssh -p ${SSH_PORT}" "${SERVER}:${src}" "${dest}"
}

remote_setup_env() {
  local env_args=()
  if [[ -n "${SETUP_USER:-}" ]]; then
    env_args+=("SETUP_USER=${SETUP_USER}")
  fi
  if [[ -n "${CATPPUCCIN_FLAVOR:-}" ]]; then
    env_args+=("CATPPUCCIN_FLAVOR=${CATPPUCCIN_FLAVOR}")
  fi
  if [[ -n "${SKIP_CHSH:-}" ]]; then
    env_args+=("SKIP_CHSH=${SKIP_CHSH}")
  fi
  printf '%s\n' "${env_args[@]}"
}
