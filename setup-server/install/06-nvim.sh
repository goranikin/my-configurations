#!/usr/bin/env bash
# Deploy minimal Neovim config with Catppuccin (via lazy.nvim).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=../lib/common.sh
source "${ROOT_DIR}/lib/common.sh"

setup_target_user

NVIM_CONFIG_DIR="${TARGET_HOME}/.config/nvim"
NVIM_INIT="${NVIM_CONFIG_DIR}/init.lua"
TEMPLATE="${ROOT_DIR}/config/nvim/init.lua"
marker="# installed by comet setup"

if ! command -v nvim >/dev/null 2>&1; then
  die "neovim is not installed. Run the base step first."
fi

if [[ -f "${NVIM_INIT}" ]] && ! grep -qF "${marker}" "${NVIM_INIT}"; then
  warn "Existing ${NVIM_INIT} found; backing up to init.lua.bak-comet"
  run_as_target_user cp "${NVIM_INIT}" "${NVIM_INIT}.bak-comet"
fi

log "Installing Neovim config (Catppuccin: ${CATPPUCCIN_FLAVOR})"
run_as_target_user mkdir -p "${NVIM_CONFIG_DIR}"

sed "s/__CATPPUCCIN_FLAVOR__/${CATPPUCCIN_FLAVOR}/" "${TEMPLATE}" \
  | run_as_target_user tee "${NVIM_INIT}" >/dev/null

run_as_target_user sed -i "1i -- ${marker}" "${NVIM_INIT}"

log "Bootstrapping Neovim plugins (lazy.nvim + catppuccin)"
run_as_target_user nvim --headless "+Lazy! sync" +qa

log "Neovim ready: $(run_as_target_user nvim --version | head -1)"
