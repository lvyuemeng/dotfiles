function Set-BrootAlias {
    $script:brootAlias = 'br'
    Set-Alias -Name $script:brootAlias -Value 'broot' -Scope Script
}

function mine {
    cd C:\Users\nostalgia\Unified\Mine
}

function Set-ProjAlias {
    $script:ProjAlias = 'Proj'
    Set-Alias -Name $script:ProjAlias -Value 'Project' -Scope Script
}

function Set-OhMyPosh {
    oh-my-posh init pwsh --config "https://fastly.jsdelivr.net/gh/Weidows-projects/Programming-Configuration@master/others/pwsh/weidows.omp.json" | Invoke-Expression
}

function Set-Starship {
    Invoke-Expression (&starship init powershell)
}

function Evoke {
    fnm env --use-on-cd | Out-String | Invoke-Expression
    Invoke-Expression "$(vfox activate pwsh)"
}

function Initialize-Environment {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    Set-ProjAlias
    Set-BrootAlias
    Set-Starship
    # Set-OhMyPosh
    Evoke

    $env:STARSHIP_CONFIG = "~\.config\starship.toml"
    $env:EDITOR = "code.cmd"
    $env:SHELL = "pwsh"
}

Initialize-Environment

