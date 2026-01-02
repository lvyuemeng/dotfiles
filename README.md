## Dotfiles

Mine dotfiles based on [`chezmoi`](https://www.chezmoi.io) which is a well-known dotfiles manager. It's suggested that acquire the basic knowledge of operation by `chezmoi` first.

Selected special apps list in case:

**CLI**:
- restic: a open source backup program.
- openlist: a open source support multiple storage connection in cloud.
- eget: easy pre-built binary installation.
- aria2c: a lightweight downloader.

---

### Caveat

- Currently it's still under-developing.

- You **should not** take the repo as your dotfiles template without reading below method used in my dotfiles.

---

### Home Encryption:

I use `rage` to configure it by [`chezmoi` tutorial](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/#how-do-i-configure-chezmoi-to-encrypt-files-but-only-request-a-passphrase-the-first-time-chezmoi-init-is-run):

```bash
# cd to source home
chezmoi cd ~
rage-keygen -o "key.txt"
# -a: --armor
# -p: --passphrase
rage -a -p "key.txt" > "key.txt.age"
```

It configure a key with your custom passphrase as the home entry. Then add the `key.txt` to `.chezmoiignore`.

Apply below `chezmoi.toml` configuration for public key detection.

```toml
encryption = "age" # this should be on top of the config file to avoid variable shadow
[age]
	command = "rage"
    identity = # Your identity "key.txt" path
    recipient = # Your public key in `rage-keygen`
```

With [powershell](./.chezmoiscripts/windows/run_once_before_00-decrypt-home.ps1.tmpl) and [bash](./.chezmoiscripts/linux/run_once_before_00-decrypt-home.sh.tmpl) script in attribute `run_once_before` to automatically achieve the decryption for public key in initiation.

#### Re-modify Encryption

- Do not forget removing original decrypted key identity in your path for ease.

- Remove your original key in source and the related configuration in `chezmoi`. Then follows the previous procedure to add a new key.

- Apply `chezmoi init` to reload your key identity.

### Data Encryption

> You should configure **Home Encryption** first.

First configure your data text in `.chezmoidata` readable format, we choose `toml` here.

Add the file into source in encryption.

```bash
chezmoi add --encrypt [data path]
```

Use the template functionality of `chezmoi` to decrypt it in [.chezmoitemplates](./.chezmoitemplates/data) by including the file in source and decrypt it automatically.

```
# ./.chezmoitemplates/(data name or any name you want)

# Data(Toml) is auto generated from .config/data.toml, Do not edit directly.

{{ joinPath .chezmoi.sourceDir "dot_config/encrypted_(data name).toml.age" | include | decrypt }}
```

Then you can apply the data to any template you want e.g.

```
{{/* Load data.toml to access encrypted data */}}
{{- $secret := includeTemplate "path-to-your-data" . | fromToml -}}
{{- $something := $secret.some-field -}}
```

### Auto Installation

> Based on [`chezmoi` tutorial](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/).

First declare a `pkg.toml/.yml` or any readable format in `chezmoidata`, with any nested structure you like in [pkgs.yml](./.chezmoidata/pkgs.yml):

```yml
enabled_roles:
  - base

roles:
  base:
    scoop:
      - name: "ansicon"
...
```

I apply a `roles` design in aid of selection.

Then apply corresponding [powershell](./.chezmoiscripts/windows/run_onchange_after_00-install-pkg.ps1.tmpl) or [bash]() e.g.

```ps1
{{- range $role := .enabled_roles }}
    {{- with (index $.roles $role "scoop") }}
        {{- range $pkg := . }}

& scoop install {{ $pkg.name }} {{ with (index $pkg "args") }}{{ . }}{{ end }}
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to install {{ $pkg.name }}" }

        {{- end }}
    {{- end }}

    {{- with (index $.roles $role "winget") }}
        {{- range $pkg := . }}

& winget install {{ $pkg.name }} {{ with (index $pkg "args") }}{{ . }}{{ end }} 
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to install {{ $pkg.name }}" }

        {{- end }}
    {{- end }}
{{- end }}
```

### Q.A

> Some problem is a mix of `go template` with `chezmoi` specific design. I list a few encountered as a memo.

#### Go template

`tmpl` design has a few fuzzy cases in syntax:

- When you want to index some `.chezmoidata`, you should use `(index $(data) (field))` e.g.

**Correct**:

```
(index $.roles $role "winget")
```

**Wrong**:

```
(index .roles $role "winget")
```

Otherwise it will output error that `.roles is {}`, but such case only *occur* when you use **variable field** like `$role` above. It's fine to use `(index .roles "something")` for predefined instance.

- You should get fields by `with (index $pkg "args" )` rather than directly `with $pkg.args`.
The latter case will cause same error above.

---

#### Intepreters

Some `ps1` script only works when you use `pwsh(>= 7.0)` rather `powershell(5.0)`. Bsed on [chezmoi:interpreters](https://www.chezmoi.io/reference/configuration-file/interpreters/) to change the shell of the script.

> If you intend to use PowerShell Core (pwsh.exe) as the .ps1 interpreter, include the following in your config file:
> 
> ```toml
> ~/.config/chezmoi/chezmoi.toml
> [interpreters.ps1]
>     command = "pwsh"
>     args = ["-NoLogo"]
> ```
