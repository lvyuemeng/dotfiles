# Mechanisms

> Key implementation details and how components interact.

| Mechanism | Implementation |
|---|---|
| Shell detection | `.chezmoi.toml.tmpl` — `pwsh > powershell` (Windows), `fish > bash` (Unix) |
| Editor detection | `.chezmoi.toml.tmpl` — `zed > nvim > code` (all platforms) |
| Encryption (home key) | `rage`/`age` — identity bootstrapped by `run_once_before_00` |
| Secrets | `encrypted_data.toml.age` decrypted via `.chezmoitemplates/data` |
| Package install (Windows) | `dot_winspec.ps1` + `install.psm1` — roles-based Scoop/Winget |
| Package install (Linux) | `flake.nix` — Nix `buildEnv` for core CLI tools |
| DB backup | `run_before_01-backup-db` (hash-gated) for openlist DB |
| External (nvim config) | `git-repo` via `.chezmoiexternals/universal.toml.tmpl` |
| Prompt | Starship, Catppuccin Mocha |
| Terminal | WezTerm — cross-platform, auto shell detection |
| Windows spec | WinSpec declarative feature/registry state |
| File backup | resticprofile + S3 |
| GitHub mirror | `global.yml` — unconditional proxy via `gh-proxy.com` |