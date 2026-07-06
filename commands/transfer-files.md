# Transfer Files

Copy files between your local machine and a remote Ubuntu server.

## scp — simple one-off copies

### Local → server

```bash
scp ./file.txt user@host:~/
scp -r ./my-project/ user@host:~/projects/
scp -P 2222 ./file.txt user@host:~/
```

### Server → local

```bash
scp user@host:~/file.txt ./
scp -r user@host:~/logs/ ./logs/
```

## rsync — preferred for directories

`rsync` only transfers changes and is better for syncing folders (e.g. `setup-server/`).

### Local → server

```bash
rsync -avz ./setup-server/ user@host:~/setup-server/
```

| Flag | Meaning |
|------|---------|
| `-a` | Archive mode (preserves permissions, symlinks, times) |
| `-v` | Verbose |
| `-z` | Compress during transfer |
| `--delete` | Remove files on destination that no longer exist locally (use carefully) |

With delete (mirror local to remote):

```bash
rsync -avz --delete ./setup-server/ user@host:~/setup-server/
```

### Server → local

```bash
rsync -avz user@host:~/data/ ./data/
rsync -avz user@host:~/setup-server/logs/ ./logs/
```

### Custom SSH port

```bash
rsync -avz -e 'ssh -p 2222' ./setup-server/ user@host:~/setup-server/
```

## sftp — interactive file browser

```bash
sftp user@host
```

Inside `sftp`:

```
put local-file.txt remote-path/
get remote-file.txt ./
lcd /local/path
cd /remote/path
ls
```

## Compare methods

| Tool | Best for |
|------|----------|
| `scp` | Single files, quick copies |
| `rsync` | Directories, repeated syncs, large projects |
| `sftp` | Browsing remote filesystem interactively |

## Exclude files (rsync)

```bash
rsync -avz --exclude '.git' --exclude '__pycache__' ./project/ user@host:~/project/
```

## Check transfer size first (dry run)

```bash
rsync -avzn ./setup-server/ user@host:~/setup-server/
```

The `-n` flag shows what would be transferred without copying.
