# Ubuntu System

Inspect and manage a running Ubuntu server or container.

## System info

```bash
uname -a                         # kernel and architecture
lsb_release -a                   # Ubuntu version
hostnamectl                      # hostname, OS, kernel
uptime                           # load average, uptime
nproc                            # CPU cores
lscpu                            # detailed CPU info
free -h                          # memory usage
df -h                            # disk usage by mount
du -sh /path/*                   # directory sizes
```

## Processes

```bash
htop                             # interactive process viewer (if installed)
ps aux | grep python             # find processes
pgrep -a python                  # find PIDs by name
kill PID                         # stop process
kill -9 PID                      # force stop
pkill -f "python train.py"       # kill by command pattern
```

## Logs

```bash
journalctl -xe                   # recent system logs
journalctl -u nginx -f           # follow service logs
dmesg | tail                     # kernel messages
tail -f /var/log/syslog          # classic syslog (if present)
```

## Users and permissions

```bash
whoami
id
cat /etc/passwd | grep ubuntu
sudo adduser dev                   # create user
sudo usermod -aG sudo dev          # grant sudo
sudo chown -R dev:dev ~/project    # change ownership
chmod +x script.sh                 # make executable
chmod 600 ~/.ssh/authorized_keys   # restrict SSH keys file
```

## Default shell

```bash
echo $SHELL
chsh -s $(which zsh)               # change your shell to zsh
cat /etc/shells                    # list allowed shells
```

## Networking

```bash
ip a                             # network interfaces and IPs
ss -tlnp                         # listening TCP ports
curl -I https://example.com      # test HTTP
ping -c 3 8.8.8.8                # test connectivity
```

## Find files

```bash
find ~ -name "*.py" -type f
find . -mtime -1                 # modified in last 24 hours
locate filename                  # fast search (needs mlocate DB)
```

## Compression

```bash
tar -xzf archive.tar.gz          # extract
tar -czf backup.tar.gz ./dir/    # create archive
unzip file.zip                   # extract zip (needs unzip package)
```

## Environment

```bash
env                              # all environment variables
echo $PATH
export PATH="$HOME/.local/bin:$PATH"
source ~/.zshrc                  # reload shell config
```

## Container-specific tips

```bash
# Am I in a container?
systemd-detect-virt 2>/dev/null || true
cat /proc/1/cgroup

# Running as root?
id -u    # 0 means root
```

In Docker/containers, `chsh` often fails — use `SKIP_CHSH=1` when running `setup-server/setup.sh`.
