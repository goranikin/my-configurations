#!/usr/bin/env bash
# Install zsh and Oh My Zsh (unattended).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

require_ubuntu
setup_target_user

if [[ "${EUID}" -eq 0 && -z "${SETUP_USER}" ]]; then
  warn "Running as root without SETUP_USER. Oh My Zsh will install for root."
fi

if ! command -v zsh >/dev/null 2>&1; then
  if [[ "${EUID}" -eq 0 ]]; then
    log "Installing zsh"
  else
    die "zsh is not installed. Run 01-base-packages.sh as root first."
  fi
  require_root_for_apt
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq
  apt-get install -y --no-install-recommends zsh
fi

OMZ_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

if [[ -d "${TARGET_HOME}/.oh-my-zsh" ]]; then
  log "Oh My Zsh already installed at ${TARGET_HOME}/.oh-my-zsh"
else
  log "Installing Oh My Zsh for ${TARGET_USER}"
  run_as_target_user env RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL "${OMZ_INSTALL_URL}")" "" --unattended
fi

if [[ "${SKIP_CHSH:-0}" != "1" ]]; then
  zsh_path="$(command -v zsh)"
  current_shell="$(getent passwd "${TARGET_USER}" | cut -d: -f7)"
  if [[ "${current_shell}" != "${zsh_path}" ]]; then
    log "Setting default shell to zsh for ${TARGET_USER}"
    if [[ "${EUID}" -eq 0 ]]; then
      chsh -s "${zsh_path}" "${TARGET_USER}"
    else
      chsh -s "${zsh_path}" || warn "Could not change shell. Set SKIP_CHSH=1 to skip."
    fi
  fi
else
  log "Skipping chsh (SKIP_CHSH=1)"
fi

log "zsh and Oh My Zsh ready"
