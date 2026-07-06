# GitHub SSH

Set up SSH on a **remote server** so you can `git clone` over SSH.

## 1. Generate a key

On the **server**:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519
```

## 2. Add the public key to GitHub

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the output. In GitHub: **Settings → SSH and GPG keys → New SSH key** — paste and save.

## 3. Test

```bash
ssh -T git@github.com
```

## 4. Clone

```bash
git clone git@github.com:OWNER/REPO.git
```
