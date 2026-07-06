#!/usr/bin/env bash
# Copy a file or directory from the server to your local machine.
#
# Usage:
#   SERVER=user@host ./commands/pull-from-server.sh REMOTE_PATH [LOCAL_PATH]

set -euo pipefail

# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

if [[ $# -lt 1 ]]; then
  echo "usage: SERVER=user@host $0 REMOTE_PATH [LOCAL_PATH]" >&2
  exit 1
fi

remote_path="$1"
local_path="${2:-.}"

require_server

echo "==> Pulling ${SERVER}:${remote_path} → ${local_path}"
rsync_from_server "${remote_path}" "${local_path}"
echo "==> Done"
