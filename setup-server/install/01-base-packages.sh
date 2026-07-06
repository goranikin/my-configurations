#!/usr/bin/env bash
# Install baseline Ubuntu packages for remote dev containers.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/common.sh
source "${SCRIPT_DIR}/../lib/common.sh"

require_ubuntu
require_root_for_apt

log "Updating apt package index"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq

log "Installing base packages"
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
  zsh \
  locales \
  tar \
  neovim \
  less

log "Generating en_US.UTF-8 locale"
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

log "Base packages installed"
