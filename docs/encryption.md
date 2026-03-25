# Encryption Guide

> Setting up age/rage encryption for home key and secrets.

## Home Encryption

Use `rage` to configure per [chezmoi tutorial](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/):

```bash
# cd to source home
chezmoi cd ~
rage-keygen -o "key.txt"
# -a: --armor, -p: --passphrase
rage -a -p "key.txt" > "key.txt.rage"
```

Add `key.txt.rage` to `.chezmoiignore`.

### chezmoi.toml config

Add your public key to recipient.

```toml
encryption = "age"
[age]
    command = "rage"
    identity = # Your identity "key.txt" path
    recipient = # Your public key from rage-keygen
```

### Auto-decrypt on init

- [Windows](/home/.chezmoiscripts/windows/run_onchange_before_00-decrypt-home.ps1.tmpl)
- [linux](/home/.chezmoiscripts/linux/run_onchange_before_00-decrypt-home.sh.tmpl)

It will use rage to decrypt the `key.txt.rage` into the expected path configured
in `identity` field.

### Re-encrypt

If you want to change your passphrase, re-apply above workflow again.

Due to recipient changed, you should change all encrypted file again.

```powershell
& chezmoi managed --include encrypted --path-style absolute |
Where-Object { Test-Path $_ } |
ForEach-Object {
    $encrypted_file = $_

    chezmoi forget "$encrypted_file"

    # remove .asc suffix
    if ($encrypted_file -match '\.asc$') {
        $decrypted_file = $encrypted_file -replace '\.asc$', ''
    } else {
        Write-Warning "Skipping (not .asc): $encrypted_file"
        return
    }

    chezmoi add --encrypt "$decrypted_file"
}
```

```bash
for encrypted_file in $(chezmoi managed --include encrypted --path-style absolute)
do
  # optionally, add --force to avoid prompts
  chezmoi forget "$encrypted_file"

  # strip the .asc extension
  decrypted_file="${encrypted_file%.asc}"

  chezmoi add --encrypt "$decrypted_file"
done
```

Above script

## Data Encryption

> Requires Home Encryption first.

1. Create data in `.chezmoidata` (e.g., `toml` format) or any other path.
2. Add to source and encrypt:

```bash
chezmoi add --encrypt [data path]
```

3. Create template in `.chezmoitemplates/(name)`:

```text
{{ joinPath .chezmoi.sourceDir "dot_config/encrypted_(name).toml.age" | include 
| decrypt }}
```

4. Use in any template:

```text
{{- $secret := includeTemplate "path-to-your-data" . | fromToml -}}
{{- $something := $secret.some-field -}}
```

## Re-modify Encryption

1. Remove decrypted key identity from path
2. Remove original key from source and chezmoi config
3. Follow Home Encryption steps to add new key
4. Run `chezmoi init` to reload identity
