#!/usr/bin/env bash
# Full Ubuntu container bootstrap for remote dev environments.
#
# Usage:
#   sudo ./setup.sh                  # run everything
#   sudo SETUP_USER=dev ./setup.sh   # install user tools for 'dev'
#   ./setup.sh --only uv zellij      # run selected steps
#   CATPPUCCIN_FLAVOR=frappe ./setup.sh
#
# Steps: base | zsh | uv | zellij | catppuccin | nvim

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${ROOT_DIR}/install"

# shellcheck source=lib/common.sh
source "${ROOT_DIR}/lib/common.sh"

ALL_STEPS=(base zsh uv zellij catppuccin nvim)

usage() {
  cat <<EOF
Ubuntu container setup scripts

Usage:
  setup.sh [options] [steps...]

Options:
  -h, --help          Show this help
  --only STEPS...     Run only the listed steps
  --list              List available steps

Steps (default: all):
  base        apt packages (requires root)
  zsh         zsh + Oh My Zsh
  uv          Astral uv installer
  zellij      zellij binary from GitHub releases
  catppuccin  Catppuccin theme for OMZ and Zellij
  nvim        Neovim + Catppuccin (lazy.nvim)

Environment:
  SETUP_USER          Target user when running as root (e.g. dev)
  CATPPUCCIN_FLAVOR   mocha | frappe | macchiato | latte (default: latte)
  SKIP_CHSH=1         Do not change default shell

Examples:
  sudo ./setup.sh
  sudo SETUP_USER=ubuntu SKIP_CHSH=1 ./setup.sh
  sudo ./setup.sh --only base zsh catppuccin
  CATPPUCCIN_FLAVOR=macchiato ./setup.sh --only catppuccin
EOF
}

step_script() {
  case "$1" in
    base) echo "${INSTALL_DIR}/01-base-packages.sh" ;;
    zsh) echo "${INSTALL_DIR}/02-zsh-omz.sh" ;;
    uv) echo "${INSTALL_DIR}/03-uv.sh" ;;
    zellij) echo "${INSTALL_DIR}/04-zellij.sh" ;;
    catppuccin) echo "${INSTALL_DIR}/05-catppuccin.sh" ;;
    nvim) echo "${INSTALL_DIR}/06-nvim.sh" ;;
    *) die "Unknown step: $1" ;;
  esac
}

run_step() {
  local step="$1"
  local script
  script="$(step_script "${step}")"
  [[ -x "${script}" ]] || chmod +x "${script}"
  log "Running step: ${step}"
  bash "${script}"
}

selected_steps=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --list)
      printf '%s\n' "${ALL_STEPS[@]}"
      exit 0
      ;;
    --only)
      shift
      while [[ $# -gt 0 && "$1" != --* ]]; do
        selected_steps+=("$1")
        shift
      done
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        selected_steps+=("$1")
        shift
      done
      ;;
    -*)
      die "Unknown option: $1"
      ;;
    *)
      selected_steps+=("$1")
      shift
      ;;
  esac
done

if [[ ${#selected_steps[@]} -eq 0 ]]; then
  selected_steps=("${ALL_STEPS[@]}")
fi

require_ubuntu
setup_target_user

log "Target user: ${TARGET_USER} (${TARGET_HOME})"
log "Catppuccin flavor: ${CATPPUCCIN_FLAVOR}"

for step in "${selected_steps[@]}"; do
  run_step "${step}"
done

log "Setup complete"
