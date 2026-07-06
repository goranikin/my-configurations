# SSH

Connect to a remote Ubuntu server or container.

## Basic connection

```bash
ssh user@host
ssh user@203.0.113.10
ssh -p 2222 user@host          # custom port
```

## SSH config (recommended)

Edit `~/.ssh/config` on your **local** machine:

```
Host my-server
  HostName 203.0.113.10
  User ubuntu
  Port 22
  IdentityFile ~/.ssh/id_ed25519
```

Then connect with:

```bash
ssh my-server
```

## Copy your SSH key (first-time setup)

```bash
ssh-copy-id user@host
# or with a specific key
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@host
```

## Run a single command without opening a shell

```bash
ssh user@host 'uname -a'
ssh user@host 'cd ~/setup-server && ls -la'
```

## Port forwarding

Forward a remote port to your local machine (e.g. remote Jupyter on 8888):

```bash
ssh -L 8888:localhost:8888 user@host
# then open http://localhost:8888 locally
```

## Copy SSH agent (optional)

Use local SSH keys on the remote host without copying private keys:

```bash
ssh -A user@host
```

Add to `~/.ssh/config`:

```
Host my-server
  ForwardAgent yes
```

## Troubleshooting

```bash
# Verbose output for debugging
ssh -v user@host

# Check which key is offered
ssh -v user@host 2>&1 | grep "Offering"

# Fix common permission errors on server
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
