# Commands Reference

Practical Ubuntu and remote-server commands. Copy-paste and replace placeholders like `user@host`.

## Guides

| Topic | File |
|-------|------|
| SSH into a server | [ssh.md](ssh.md) |
| GitHub SSH on a remote server | [github-ssh.md](github-ssh.md) |
| Copy files local ↔ server | [transfer-files.md](transfer-files.md) |
| Push & run `setup-server` on a remote machine | [remote-setup.md](remote-setup.md) |
| Install and manage packages (`apt`) | [ubuntu-packages.md](ubuntu-packages.md) |
| Disk, processes, logs, users | [ubuntu-system.md](ubuntu-system.md) |

## Quick reference

```bash
# Connect
ssh user@host

# Copy local → server
rsync -avz ./setup-server/ user@host:~/setup-server/

# Copy server → local
rsync -avz user@host:~/data/ ./data/

# Run setup on server
ssh user@host 'cd ~/setup-server && sudo ./setup.sh'
```

## Tip: shell alias

Add to `~/.zshrc` on your local machine:

```bash
export SERVER=user@my-server
alias s='ssh $SERVER'
```
