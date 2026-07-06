#!/usr/bin/env bash
# Install zellij from official GitHub release binary.
# https://zellij.dev/documentation/installation.html

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

if command -v zellij >/dev/null 2>&1; then
  log "zellij already installed: $(zellij --version)"
  exit 0
fi

asset="$(detect_zellij_asset)"
version="$(curl -fsSL https://api.github.com/repos/zellij-org/zellij/releases/latest \
  | sed -n 's/.*"tag_name": "\([^"]*\)".*/\1/p' | head -1)"
download_url="https://github.com/zellij-org/zellij/releases/download/${version}/${asset}"

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

log "Downloading zellij ${version} (${asset})"
curl -fsSL "${download_url}" -o "${tmpdir}/zellij.tar.gz"
tar -xzf "${tmpdir}/zellij.tar.gz" -C "${tmpdir}"
chmod +x "${tmpdir}/zellij"

install_dir="/usr/local/bin"
if [[ "${EUID}" -ne 0 ]]; then
  install_dir="${HOME}/.local/bin"
  mkdir -p "${install_dir}"
fi

log "Installing zellij to ${install_dir}/zellij"
mv "${tmpdir}/zellij" "${install_dir}/zellij"

log "zellij ready: $("${install_dir}/zellij" --version)"
