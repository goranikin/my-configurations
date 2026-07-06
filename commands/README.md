# Server Commands

Helper scripts for working with remote servers from your local machine.

## Prerequisites

- `ssh` and `rsync` on your local machine
- SSH key access to the target server (`ssh SERVER` should work without a password prompt)

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVER` | *(required)* | SSH target, e.g. `ubuntu@203.0.113.10` |
| `REMOTE_DIR` | `~/setup-server` | Where setup scripts live on the server |
| `SSH_PORT` | `22` | SSH port |
| `SETUP_USER` | *(unset)* | Passed to remote `setup.sh` when configuring a non-root user |
| `CATPPUCCIN_FLAVOR` | `latte` | Passed to remote setup |

## Commands

### `push-to-server.sh`

Copy the `setup-server/` directory to the remote machine.

```bash
SERVER=user@host ./commands/push-to-server.sh
```

### `run-remote-setup.sh`

Run `setup.sh` on the server over SSH.

```bash
SERVER=user@host ./commands/run-remote-setup.sh
SERVER=user@host ./commands/run-remote-setup.sh --only base zsh
SERVER=user@host ./commands/run-remote-setup.sh --push   # push first, then run
```

### `ssh-server.sh`

Open an SSH session to `SERVER`.

```bash
SERVER=user@host ./commands/ssh-server.sh
```

### `pull-from-server.sh`

Copy a file or directory from the server to your local machine.

```bash
SERVER=user@host ./commands/pull-from-server.sh REMOTE_PATH [LOCAL_PATH]
```

Examples:

```bash
# Pull a remote file into the current directory
SERVER=user@host ./commands/pull-from-server.sh ~/project/config.yaml

# Pull into a specific local path
SERVER=user@host ./commands/pull-from-server.sh ~/logs/ ./logs/
```
