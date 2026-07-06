# Comet Scripts

Personal automation for remote servers and dev containers.

## Directories

| Directory | Purpose |
|-----------|---------|
| [`setup-server/`](setup-server/) | Bootstrap scripts for fresh Ubuntu containers |
| [`commands/`](commands/) | Ubuntu command reference (SSH, file transfer, apt, system) |

## Typical workflow

```bash
# 1. Copy setup scripts to a server (see commands/transfer-files.md)
rsync -avz ./setup-server/ user@host:~/setup-server/

# 2. Run setup on the server (see commands/remote-setup.md)
ssh user@host 'cd ~/setup-server && sudo ./setup.sh'
```

## On GitHub?

Yes — repos like this are common. People often call them **dotfiles** (shell/editor configs) or **bootstrap** / **infra** repos (server setup scripts). Examples:

- [holman/dotfiles](https://github.com/holman/dotfiles) — classic dotfiles + install scripts
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) — macOS/Linux shell setup
- [webpro/awesome-dotfiles](https://github.com/webpro/awesome-dotfiles) — curated list of approaches

Your `setup-server` folder fits the bootstrap pattern: version-controlled, repeatable container setup you can clone or rsync anywhere.
