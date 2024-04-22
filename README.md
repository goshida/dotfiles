# dotfiles

## Arch Linux Installation

[archlinux-install.md](./docs/archlinux-install.md)

## dotfiles

```bash
git clone --recursive https://github.com/goshida/dotfiles.git
cd dotfiles

make setup-desktop

make deploy-dotfiles
```

## secrets

```bash
make archive-secrets
```

```bash
./scripts/deploy-secrets.sh <secrets.tar.gz>
```

