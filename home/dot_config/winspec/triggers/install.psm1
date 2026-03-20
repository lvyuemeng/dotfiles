$script:Config = @{
    EnabledRoles = @("base", "dev", "backup", "utils")
    Roles        = @{
        base   = @{
            Scoop  = @("7zip", "git", "starship", "rage", "neovim", "aria2", "bat", "fd", "fzf",
                "ripgrep", "tree-sitter", "scoop-search", "eget", "just",
                "Maple-Mono", "Maple-Mono-NF", "Maple-Mono-NF-CN", "clash-verge-rev")
            Winget = @("Microsoft.PowerToys", "Microsoft.PowerShell", "MartiCliment.UniGetUI", "GitHub.cli")
        }
        daily  = @{
            Winget = @(
                @{ Name = "Vivaldi.Vivaldi"; Flags = @("-i") }
                @{ Name = "Valve.Steam"; Flags = @("-i") }
                @{ Name = "EpicGames.EpicGamesLauncher"; Flags = @("-i") }                
                @{ Name = "Tencent.QQ"; Flags = @("-i") }
            )
        }
        # ... other roles remain the same
        utils  = @{ Winget = @( @{Name = "Anki.Anki"; Flags = @("-i") }, @{Name = "DigitalScholar.Zotero"; Flags = @("-i") } ) }
        dev    = @{ Scoop = @("aqua", "pixi", "hugo-extended"); Winget = @("Rustlang.Rustup", "Microsoft.VisualStudioCode") }
        backup = @{ Scoop = @("restic", "resticprofile", "openlist") }
    }
}

function Get-ProviderInfo {
    return @{ Name = "PackageInstall"; Type = "Trigger" }
}

# PS 5.1 compatible normalization (Replaced ?? operator)
function Resolve-Package {
    param([object]$pkg)
    if ($pkg -is [string]) { 
        return @{ Name = $pkg; Flags = @() } 
    }
    $flags = if ($null -ne $pkg.Flags) { $pkg.Flags } else { @() }
    return @{ Name = $pkg.Name; Flags = $flags }
}

# Improved execution with specific error capturing
function Invoke-Package {
    param(
        [string]$provider, 
        [string]$role, 
        [hashtable]$pkg, 
        [string[]]$baseArgs, 
        [bool]$dryRun
    )
    
    $allArgs = $baseArgs + $pkg.Flags + $pkg.Name
    $status = "Success"
    
    if (-not $dryRun) {
        try {
            # Use ArgumentList to prevent string injection/parsing issues in PS 5.1
            Start-Process -FilePath $provider -ArgumentList $allArgs -Wait -NoNewWindow -ErrorAction Stop
            if ($LASTEXITCODE -ne 0) { $status = "Failed" }
        } catch {
            $status = "Failed"
        }
    } else {
        $status = "DryRun"
    }

    return [PSCustomObject]@{
        Provider = $provider
        Role     = $role
        Package  = $pkg.Name
        Flags    = $pkg.Flags -join " "
        Status   = $status
    }
}

function Invoke-Trigger {
    param($Option)

    if ($Option) {
        $Option = @{}
    }
    # PS 5.1 compatible default values
    $roles   = if ($Option.ContainsKey('Roles'))  { $Option.Roles }  else { $script:Config.EnabledRoles }
    $dryRun  = if ($Option.ContainsKey('DryRun')) { $Option.DryRun } else { $false }
    $force   = if ($Option.ContainsKey('Force'))  { $Option.Force }  else { $false }

    $scoopBase = @("install")
    if ($force) { $scoopBase += "--force" }

    $wingetBase = @("install", "--accept-source-agreements", "--accept-package-agreements")
    if ($force) { $wingetBase += "--force" }

    $results = New-Object System.Collections.Generic.List[object]
    $errors  = New-Object System.Collections.Generic.List[string]

    foreach ($role in $roles) {
        if (-not $script:Config.Roles.ContainsKey($role)) {
            $errors.Add("Unknown role: '$role'")
            continue
        }
        
        $roleDef = $script:Config.Roles[$role]

        # Generic processor for both providers
        foreach ($prov in @("Scoop", "Winget")) {
            if ($null -eq $roleDef[$prov]) { continue }
            
            foreach ($raw in $roleDef[$prov]) {
                $pkg = Resolve-Package $raw
                $cmd = $prov.ToLower()
                
                # Logic: Winget needs --silent UNLESS -i is present
                $currentBase = if ($cmd -eq "winget") {
                    if ($pkg.Flags -contains "-i") { $wingetBase } else { $wingetBase + "--silent" }
                } else {
                    $scoopBase
                }

                Write-Host "Install package: $($pkg["Name"])"
                $res = Invoke-Package $cmd $role $pkg $currentBase $dryRun
                $results.Add($res)
                if ($res.Status -eq "Failed") { $errors.Add("[$cmd]: $($pkg.Name) [$role]") }
            }
        }
    }

    $failedCount = ($results | Where-Object { $_.Status -eq "Failed" }).Count
    return @{
        Status  = if ($failedCount -eq 0) { "Success" } else { "PartialFailure" }
        Message = "Processed $($results.Count) package(s). Succeeded: $($results.Count - $failedCount) Failed: $failedCount"
        Results = $results
        Errors  = $errors
    }
}

Export-ModuleMember -Function "Get-ProviderInfo", "Invoke-Trigger"