# Dotfiles

Dotfiles managed with [chezmoi](https://www.chezmoi.io).

## Features

- **Encryption**: age/rage-based home key and data encryption
- **Auto Installation**: Declarative package management via roles
(scoop, winget, nix)
- **Cross-platform**: Windows (PowerShell) and Linux (bash) support (partially)

## No Quick Start

The project is developed by self-usage, there's no way to apply
the configuration instantly.

If you really admire the project and urge to use it, please read below documentations
for further investigation.

Windows:

```powershell
winget install twpayne.chezmoi
chezmoi init
chezmoi apply -v
```

Unix:

Below, you should ensure you have `curl`, `tar`.

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply lvyuemeng
```

Currently, Unix only support partially excluding cloud storage.

## Documentation

- [Architecture](./docs/overview.md) — Repository structure
- [Encryption](./docs/encryption.md) — Home & data encryption
- [FAQ](./docs/faq.md) — Go template quirks, interpreter configuration

## Packages

Here are packages specifically configured and provide important usage.

The declarative system management:

- [nix](https://github.com/NixOS/nix) - declarative unix system management
- [winspec](https://github.com/lvyuemeng/winspec) - declarative windows system management
- [shed](https://github.com/lvyuemeng/shed) - intepreter of declaration of envrionment

The cloud storage:

- [restic](https://github.com/restic/restic) — backup program
- [resticprofile](https://github.com/creativeprojects/resticprofile) - declarative
profile of restic
- [openlist](https://github.com/OpenListTeam/OpenList) — cloud storage manager
