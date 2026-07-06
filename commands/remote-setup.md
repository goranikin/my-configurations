# Remote Setup

Push `setup-server/` to a machine and run the bootstrap scripts.

## 1. Copy scripts to the server

From your **local** machine, in the `scripts/` repo root:

```bash
rsync -avz ./setup-server/ user@host:~/setup-server/
```

## 2. Make scripts executable

```bash
ssh user@host 'chmod +x ~/setup-server/setup.sh ~/setup-server/install/*.sh'
```

## 3. Run full setup

```bash
ssh user@host 'cd ~/setup-server && sudo ./setup.sh'
```

## Run specific steps only

```bash
ssh user@host 'cd ~/setup-server && sudo ./setup.sh --only base zsh'
ssh user@host 'cd ~/setup-server && sudo ./setup.sh --list'
```

## Configure a non-root user (containers)

When logged in as root but tools should belong to `ubuntu`:

```bash
ssh user@host 'cd ~/setup-server && sudo SETUP_USER=ubuntu SKIP_CHSH=1 ./setup.sh'
```

| Variable | Purpose |
|----------|---------|
| `SETUP_USER` | Install omz, uv, nvim config for this user |
| `SKIP_CHSH=1` | Don't change default shell (common in Docker) |
| `CATPPUCCIN_FLAVOR` | `latte`, `mocha`, `frappe`, or `macchiato` |

Example with flavor:

```bash
ssh user@host 'cd ~/setup-server && sudo CATPPUCCIN_FLAVOR=latte ./setup.sh'
```

## One-liner: push + run

```bash
rsync -avz ./setup-server/ user@host:~/setup-server/ \
  && ssh user@host 'chmod +x ~/setup-server/setup.sh ~/setup-server/install/*.sh && cd ~/setup-server && sudo ./setup.sh'
```

## Clone from GitHub instead of rsync

On the **server**:

```bash
git clone https://github.com/YOUR_USER/YOUR_REPO.git ~/scripts
cd ~/scripts/setup-server
chmod +x setup.sh install/*.sh
sudo ./setup.sh
```

## After setup

```bash
ssh user@host
exec zsh
zellij
nvim
uv --version
```
