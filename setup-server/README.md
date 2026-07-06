# Ubuntu Container Setup Scripts

Bootstrap scripts for fresh Ubuntu containers on remote servers. Installs common dev tools, shell setup, and Catppuccin theming.

## Quick start

Copy this folder to the server (see [`../commands/transfer-files.md`](../commands/transfer-files.md) or [`../commands/remote-setup.md`](../commands/remote-setup.md)), then run:

```bash
chmod +x setup.sh install/*.sh
sudo ./setup.sh
```

For a non-root user inside the container:

```bash
sudo SETUP_USER=ubuntu ./setup.sh
```

## What gets installed

| Step | Contents |
|------|----------|
| `base` | curl, git, zsh, neovim, tar, locales, … |
| `zsh` | Oh My Zsh (unattended) + default shell |
| `uv` | [uv](https://docs.astral.sh/uv/) via official installer |
| `zellij` | [zellij](https://zellij.dev/) v0.44.x binary from GitHub releases |
| `catppuccin` | OMZ theme + built-in Zellij Catppuccin theme |
| `nvim` | Neovim config with [catppuccin/nvim](https://github.com/catppuccin/nvim) via lazy.nvim |

## Install sources (July 2026)

- **Oh My Zsh**: `https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh`
- **uv**: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **zellij**: GitHub release binary (`zellij-x86_64-unknown-linux-musl` or `aarch64`)
- **OMZ Catppuccin**: [JannoTjarks/catppuccin-zsh](https://github.com/JannoTjarks/catppuccin-zsh)
- **Zellij Catppuccin**: built-in theme (`catppuccin-latte`, etc.) — no extra download
- **Neovim Catppuccin**: [catppuccin/nvim](https://github.com/catppuccin/nvim) via lazy.nvim

## Options

```bash
# Run individual steps
sudo ./setup.sh --only base zsh

# Pick Catppuccin flavor: mocha | frappe | macchiato | latte
CATPPUCCIN_FLAVOR=frappe ./setup.sh --only catppuccin

# Containers where chsh is not needed
sudo SKIP_CHSH=1 ./setup.sh
```

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SETUP_USER` | current user | User to configure when running as root |
| `CATPPUCCIN_FLAVOR` | `latte` | Catppuccin variant for OMZ, Zellij, and Neovim |
| `SKIP_CHSH` | `0` | Set to `1` to skip changing default shell |

## After setup

```bash
exec zsh          # start zsh with Catppuccin prompt
zellij            # terminal multiplexer with Catppuccin theme
nvim              # editor with Catppuccin theme
uv --version      # Python toolchain
```

## File layout

```
setup-server/
  setup.sh                 # main entry point
  lib/common.sh
  install/
    01-base-packages.sh
    ...
  config/nvim/init.lua
```
