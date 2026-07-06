#!/usr/bin/env bash
# Open an SSH session to SERVER.
#
# Usage:
#   SERVER=user@host ./commands/ssh-server.sh [ssh args...]

set -euo pipefail

# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

require_server
exec ssh -p "${SSH_PORT}" "${SERVER}" "$@"
