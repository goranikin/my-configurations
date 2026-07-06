#!/usr/bin/env bash
# Install uv (Astral Python toolchain).
# https://docs.astral.sh/uv/getting-started/installation/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

setup_target_user

UV_INSTALL_URL="https://astral.sh/uv/install.sh"

if run_as_target_user command -v uv >/dev/null 2>&1; then
  log "uv already installed: $(run_as_target_user uv --version)"
  exit 0
fi

log "Installing uv for ${TARGET_USER}"
run_as_target_user sh -c "curl -LsSf '${UV_INSTALL_URL}' | sh"

if ! run_as_target_user command -v uv >/dev/null 2>&1; then
  # Installer places binary in ~/.local/bin
  uv_bin="${TARGET_HOME}/.local/bin/uv"
  if [[ -x "${uv_bin}" ]]; then
    log "uv installed at ${uv_bin}"
  else
    die "uv install finished but binary was not found."
  fi
fi

# Ensure ~/.local/bin is on PATH in .zshrc
zshrc="${TARGET_HOME}/.zshrc"
path_marker="# added by comet setup: uv"
if [[ -f "${zshrc}" ]] && ! grep -qF "${path_marker}" "${zshrc}"; then
  log "Adding ~/.local/bin to PATH in .zshrc"
  run_as_target_user tee -a "${zshrc}" >/dev/null <<EOF

${path_marker}
export PATH="\${HOME}/.local/bin:\${PATH}"
EOF
fi

log "uv ready: $(run_as_target_user "${TARGET_HOME}/.local/bin/uv" --version 2>/dev/null || run_as_target_user uv --version)"
