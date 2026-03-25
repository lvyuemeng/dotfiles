# Architecture Overview

> High-level structure of this dotfiles repository.

## Directory Layout

```
chezmoi/
├── .chezmoiroot              → redirects to home/
├── README.md                 → User guide
└── home/
    ├── .chezmoi.toml.tmpl    → Main config (shell/editor detection, age)
    ├── .chezmoiignore.tmpl
    ├── .chezmoidata/         → Declarative data (roles, mirrors)
    ├── .chezmoiexternals/    → External repo (nvim config)
    ├── .chezmoiscripts/      → Platform scripts (decrypt, backup, install)
    ├── .chezmoitemplates/   → Template includes (shell, editor, data)
    ├── dot_config/           → App configs (starship, nix, scoop, uv, etc.)
    ├── dot_ssh/              → SSH keys and config
    ├── AppData/              → Editor settings (VSCode, Zed)
    └── scripts/              → Bootstrap scripts
```

## Core Principles

- **Shell priority**: `pwsh > powershell` (Windows), `fish > bash` (Unix)
- **Editor priority**: `zed > nvim > code` (all platforms)
- **Encryption**: `rage`/`age` for home key and secrets
- **Roles-based**: Package installation driven by `.chezmoidata` roles