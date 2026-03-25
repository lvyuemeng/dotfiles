# FAQ

> Troubleshooting and known issues.

## Go Template

### Indexing .chezmoidata with variable field

**Correct**:
```
(index $.roles $role "winget")
```

**Wrong**:
```
(index .roles $role "winget")
```

The latter causes `.roles is {}` error when using variable fields like `$role`. Predefined instances work fine with `(index .roles "something")`.

### Accessing optional fields

Use `with (index $pkg "args")` instead of `$pkg.args`. The latter causes the same error above.

## Interpreters

Some `.ps1` scripts require `pwsh` (>= 7.0), not `powershell` (5.0).

### Configure interpreter in `chezmoi.toml`:

```toml
[interpreters.ps1]
    command = "pwsh"
    args = ["-NoLogo"]
```

See [chezmoi:interpreters](https://www.chezmoi.io/reference/configuration-file/interpreters/) for details.