## Dotfiles

Mine dotfiles based on [`chezmoi`](https://www.chezmoi.io) which is a well-known dotfiles manager. It's suggested that acquire the basic knowledge of operation by `chezmoi` first.

It's mainly for `Windows` and `linux` part is still under-developing.

Some *Windows for* apps list:

- terminal: Terminal(*Windows Native*)
- shell: powershell(=5.0)/pwsh(>=7.0)
- package manager: winget(*Windows Native*)/scoop/UniGet(GUI)
- editor: vscode/neovim (*list completeness only*)

Selected special apps list:

- dev-sidecar: a side car to cross *wall*. (GUI)
- openlist: a open source support multiple storage connection in cloud. (CLI)
- eget: easy pre-built binary installation (CLI)
- aria2c: a lightweight downloader (CLI)

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

> You should remove `key.txt.rage` first and customize your key.

### Data Encryption

You should configure **Home Encryption** first.

First configure your data with a format like `.toml/.yml` etc,
we choose `toml` here.

```bash
chezmoi add --encrypt [data path]
```

Use the template functionality of `chezmoi` to decrypt it in [.chezmoitemplates](./.chezmoitemplates/data).
It include the file in source home and decrypt it automatically.

```
# ./.chezmoitemplates/(data name or any name you want)

# Data(Toml) is auto generated from .config/data.toml, Do not edit directly.

{{ joinPath .chezmoi.sourceDir "dot_config/encrypted_(data name).toml.age" | include | decrypt }}
```

Then you can apply the data to any template you want e.g.

```
{{/* Load data.toml to access encrypted data */}}
{{- $secret := includeTemplate "(template data path)" . | fromToml -}}
{{- $something := $secret.(data access field) -}}
```

### Auto Installation

It's from [`chezmoi` tutorial](https://www.chezmoi.io/user-guide/advanced/install-packages-declaratively/).

First we declare a `pkg.toml/.yml` in [.chezmoidata](./.chezmoidata/pkgs.yml) in any nested structure you like:

```yml
enabled_roles:
  - base

roles:
  base:
    scoop:
      - name: "ansicon"
...
```

I use a category design for selection ease.

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

Some problem is a mixed of `go tmpl` plus `chezmoi` design. I list few I encounter as a memo.

#### Go template

`tmpl` design has few potential syntax fuzzy case:

- When you want to index some `.chezmoidata`, you should use `(index $(data) (field))` e.g.

Correct:

```
(index $.roles $role "winget")
```

Wrong:

```
(index .roles $role "winget")
```

Otherwise it will output error that `.roles is {}`, but such case only *occur* when you use variable field like `$role` above. It's fine to use `(index .roles "something")`.

---

- When use `with`, you should check subfield like `with (index $pkg "args" )` rather `with $pkg.args`.
The latter case will cause same error above.

---

#### Intepreters

Some `ps1` script only works when you use `pwsh(>= 7.0)` rather `powershell(5.0)`. You want to use [interpreters](https://www.chezmoi.io/reference/configuration-file/interpreters/) to change the shell of the script.

> If you intend to use PowerShell Core (pwsh.exe) as the .ps1 interpreter, include the following in your config file:
> 
> ```toml
> ~/.config/chezmoi/chezmoi.toml
> [interpreters.ps1]
>     command = "pwsh"
>     args = ["-NoLogo"]
> ```
