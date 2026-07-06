#!/usr/bin/env bash
# Shared helpers for container setup scripts.

set -euo pipefail

# Catppuccin flavor: mocha | frappe | macchiato | latte
CATPPUCCIN_FLAVOR="${CATPPUCCIN_FLAVOR:-latte}"

# When running as root in a container, configure this user instead.
SETUP_USER="${SETUP_USER:-${SUDO_USER:-}}"

log() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33mwarning:\033[0m %s\n' "$*" >&2
}

die() {
  printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
  exit 1
}

require_ubuntu() {
  if [[ ! -f /etc/os-release ]]; then
    die "Cannot detect OS. These scripts target Ubuntu."
  fi
  # shellcheck source=/dev/null
  source /etc/os-release
  if [[ "${ID:-}" != "ubuntu" && "${ID_LIKE:-}" != *"ubuntu"* && "${ID_LIKE:-}" != *"debian"* ]]; then
    warn "OS is '${ID:-unknown}', not Ubuntu. Continuing anyway."
  fi
}

require_root_for_apt() {
  if [[ "${EUID}" -ne 0 ]]; then
    die "Install scripts that use apt must be run as root (or with sudo)."
  fi
}

setup_target_user() {
  if [[ -n "${SETUP_USER}" ]]; then
    if ! id "${SETUP_USER}" &>/dev/null; then
      die "SETUP_USER '${SETUP_USER}' does not exist."
    fi
    TARGET_HOME="$(getent passwd "${SETUP_USER}" | cut -d: -f6)"
    TARGET_USER="${SETUP_USER}"
  else
    TARGET_HOME="${HOME}"
    TARGET_USER="$(id -un)"
  fi
}

run_as_target_user() {
  if [[ "$(id -un)" == "${TARGET_USER}" ]]; then
    "$@"
  else
    sudo -u "${TARGET_USER}" -H "$@"
  fi
}

zellij_theme_for_flavor() {
  case "${CATPPUCCIN_FLAVOR}" in
    mocha) echo "catppuccin-mocha" ;;
    frappe) echo "catppuccin-frappe" ;;
    macchiato) echo "catppuccin-macchiato" ;;
    latte) echo "catppuccin-latte" ;;
    *)
      die "Invalid CATPPUCCIN_FLAVOR '${CATPPUCCIN_FLAVOR}'. Use: mocha, frappe, macchiato, latte"
      ;;
  esac
}

detect_zellij_asset() {
  local arch
  arch="$(uname -m)"
  case "${arch}" in
    x86_64|amd64) echo "zellij-x86_64-unknown-linux-musl.tar.gz" ;;
    aarch64|arm64) echo "zellij-aarch64-unknown-linux-musl.tar.gz" ;;
    *) die "Unsupported architecture for zellij binary: ${arch}" ;;
  esac
}
