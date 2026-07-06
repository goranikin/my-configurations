# Comet Scripts

Personal automation for remote servers and dev containers.

## Directories

| Directory | Purpose |
|-----------|---------|
| [`setup-server/`](setup-server/) | Bootstrap scripts for fresh Ubuntu containers |
| [`commands/`](commands/) | Day-to-day ops: copy files to a server, run setup remotely, SSH shortcuts |

## Typical workflow

```bash
# 1. Push setup scripts to a server
SERVER=user@my-server ./commands/push-to-server.sh

# 2. Run full setup on the server
SERVER=user@my-server ./commands/run-remote-setup.sh

# Or do both in one step
SERVER=user@my-server ./commands/run-remote-setup.sh --push
```

Set `SERVER` once in your shell profile:

```bash
export SERVER=user@my-server
```

## On GitHub?

Yes — repos like this are common. People often call them **dotfiles** (shell/editor configs) or **bootstrap** / **infra** repos (server setup scripts). Examples:

- [holman/dotfiles](https://github.com/holman/dotfiles) — classic dotfiles + install scripts
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) — macOS/Linux shell setup
- [webpro/awesome-dotfiles](https://github.com/webpro/awesome-dotfiles) — curated list of approaches

Your `setup-server` folder fits the bootstrap pattern: version-controlled, repeatable container setup you can clone or rsync anywhere.
