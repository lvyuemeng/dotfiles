function CustomAlias {
    $script:broot = "br"
    
    Set-Alias -Name $script:broot -Value 'broot' -Scope Script
}

function JumpTo {
    $jump = @{
        "mine" = "$env:USERPROFILE\Unified\Mine"
        "proj" = "$env:USERPROFILE\Unified\Mine\Proj"
    }
    
    foreach ($key in $jump.Keys) {
        New-Item -Path "Function:\$key" -Value {Set-Location $jump[$key]} | Out-Null
    }
}

function Evoke {
    # oh-my-posh
    # oh-my-posh init pwsh --config "https://fastly.jsdelivr.net/gh/Weidows-projects/Programming-Configuration@master/others/pwsh/weidows.omp.json" | Invoke-Expression
    # fnm
    fnm env --use-on-cd | Out-String | Invoke-Expression
    # vfox
    Invoke-Expression "$(vfox activate pwsh)"
    # starship
    Invoke-Expression (&starship init powershell)
}

function Initialize-Environment {
    # [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    CustomAlias
    JumpTo
    Evoke

    $env:STARSHIP_CONFIG = "$USERPROFILE\.config\starship\starship.toml"
    $env:EDITOR = "code.cmd"
    $env:SHELL = "pwsh"
}

Initialize-Environment
