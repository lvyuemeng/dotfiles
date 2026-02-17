# Roadmap: Chezmoi Dotfiles Updates

This document provides a checklist for implementing the improvements identified in [`docs/inspect.md`](docs/inspect.md).

---

## Completed Tasks

### 1. ✅ Fixed Critical Bug in `.prepare.sh`

- [x] Open [`home/scripts/.prepare.sh`](home/scripts/.prepare.sh)
- [x] Find line 37: `if [ -f "tmp/rage" ]; then`
- [x] Changed to: `if [ -f "/tmp/rage" ]; then`

### 2. ✅ Chose Package Management Approach (Hybrid)

- [x] Decided on hybrid approach (both pkgs.yml and export files)
- [x] Renamed export files to:
  - `home/dot_config/scoop/export.json` → `~/.config/scoop/export.json`
  - `home/dot_config/winget/export.json` → `~/.config/winget/export.json`
- [x] Updated script to write to new paths

### 3. ✅ Fixed Font Installation

- [x] Commented out broken chezmoiexternals font config
- [x] Created Windows script: [`home/.chezmoiscripts/windows/run_onchange_after_02-install-fonts.ps1.tmpl`](home/.chezmoiscripts/windows/run_onchange_after_02-install-fonts.ps1.tmpl)
- [x] Created Linux script: [`home/.chezmoiscripts/linux/run_onchange_after_02-install-fonts.sh.tmpl`](home/.chezmoiscripts/linux/run_onchange_after_02-install-fonts.sh.tmpl)

### 4. ✅ Synced Package Declarations (pkgs.yml)

- [x] Populated [`home/.chezmoidata/pkgs.yml`](home/.chezmoidata/pkgs.yml) with packages from exports
- [x] Created roles: base, dev, utils
- [x] Included scoop packages: 7zip, git, starship, rage, neovim, aria2, bat, eget, fd, fzf, just, restic, resticprofile, ripgrep, tree-sitter, aqua, pixi, hugo-extended, scoop-search, aichat, clash-verge-rev, openlist, pot, opencode
- [x] Included winget packages: PowerShell, WindowsTerminal, VSCode, GitHub.cli, DotNet SDK/Runtime, Rustup, LLVM, PowerToys, JetBrains.Toolbox, chezmoi, UniGetUI, Anki, Zotero

### 5. ✅ Reordered Scripts

- [x] Renamed install script: `run_onchange_after_00-install-pkg.ps1.tmpl` → `run_onchange_after_03-install-pkg.ps1.tmpl`
- [x] Script now runs after fonts (order: 01=update, 02=fonts, 03=packages)

---

## Script Execution Order

```
01-update.ps1       → Export current packages
02-fonts            → Install Nerd Fonts
03-install-pkg      → Install packages from pkgs.yml
```

---

## Remaining Tasks

### Low Priority

- [ ] Add encryption key validation
- [ ] Test auto-installation script
- [ ] Improve documentation
- [ ] Implement backup validation

---

## Notes

- Run `chezmoi status` after each change
- Test changes in a VM before applying to main machine
- Keep encrypted files backed up securely

---

*Last updated: 2026-02-17*
*Completed: All high priority tasks*
