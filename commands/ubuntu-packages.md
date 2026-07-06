# Ubuntu Packages

Manage software with `apt` on Ubuntu servers and containers.

## Update and install

```bash
sudo apt update                  # refresh package index
sudo apt upgrade -y              # upgrade installed packages
sudo apt install -y package-name # install a package
sudo apt remove -y package-name  # remove package (keep config)
sudo apt purge -y package-name   # remove package + config
sudo apt autoremove -y           # remove unused dependencies
```

## Search and inspect

```bash
apt search neovim
apt show neovim
dpkg -l | grep neovim            # list installed packages matching name
dpkg -L neovim                   # files installed by a package
which nvim                       # path of installed binary
```

## Install without prompts (scripts/containers)

```bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends curl git zsh
```

`--no-install-recommends` keeps images smaller by skipping optional packages.

## Hold a package at current version

```bash
sudo apt-mark hold package-name
sudo apt-mark unhold package-name
```

## Clean up disk space

```bash
sudo apt clean                   # clear downloaded .deb cache
sudo apt autoclean               # clear outdated cache
```

## Fix broken dependencies

```bash
sudo apt --fix-broken install
```

## Add a PPA (use sparingly on servers)

```bash
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
```

Prefer official Ubuntu packages or direct binaries in containers when possible.

## See what our setup installs

The `base` step in `setup-server` installs:

```bash
ca-certificates curl git zsh locales tar neovim less
```

See `setup-server/install/01-base-packages.sh` for the current list.
