#!/usr/bin/env bash
# Copy setup-server/ to a remote machine via rsync.
#
# Usage:
#   SERVER=user@host ./commands/push-to-server.sh

set -euo pipefail

# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

if [[ ! -d "${SETUP_SERVER_DIR}" ]]; then
  echo "error: setup-server directory not found at ${SETUP_SERVER_DIR}" >&2
  exit 1
fi

require_server

echo "==> Pushing setup-server to ${SERVER}:${REMOTE_DIR}"
rsync_to_server "${SETUP_SERVER_DIR}/" "${REMOTE_DIR}/"

echo "==> Making scripts executable on remote"
ssh_cmd "chmod +x ${REMOTE_DIR}/setup.sh ${REMOTE_DIR}/install/*.sh"

echo "==> Done. Run setup with:"
echo "    SERVER=${SERVER} ./commands/run-remote-setup.sh"
