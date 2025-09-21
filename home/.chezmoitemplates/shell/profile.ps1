# == UTILS ==
function wttr {
    param(
        [Parameter(Mandatory = $false)]
        [string]$In
    )
    & curl "wttr.in/$In"
}

function Clear-PSReadLineHistory {
    Get-PSReadLineOption | Select-Object -expand HistorySavePath | Remove-Item
}

# == ENVIRONMENT ==

function Initialize-Env {
    # explorer
    Set-Alias -Name e -Value explorer.exe -Scope Global
    # starship
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        Invoke-Expression (& starship init powershell)
        $ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
    }
    
    if (Get-Command zoxide -ErrorAction SilentlyContinue) {
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    }

    if (Get-Command code -ErrorAction SilentlyContinue) {
        $ENV:EDITOR = "code.cmd"
    }

    $ENV:SHELL = "pwsh"
}

# == MODULES ==

function Add-OwnModule {
    param (
        [Parameter(Mandatory = $true)]
        [string]$moduleName,
        [scriptblock]$Handler
    )

    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        Write-Host "Installing $moduleName..." -ForegroundColor Cyan
        Install-Module -Name $moduleName -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck
    }
    try {
        Import-Module $moduleName -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to import ${moduleName}: $_"
    }
}

function Initialize-Modules {
    $modules = @(
        "CompletionPredictor"
        "PsReadLine"
    )
    
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Warning "Module relat only support for Powershell with major version >= 7."
        return
    }

    foreach ($module in $modules) {
        Add-OwnModule -moduleName $module
    }

    # == PSReadLine ==
    $historyFilter = {
        Param([string]$line)
        if ($line -like " *") {
            return $false
        }

        $ignores = @("user", "pass", "account", "apikey", "token")

        foreach ($ignore in $ignores) {
            if ($line -match $ignore) {
                return $false
            }
        }
        return $true
    }

    $PSReadLineOptions = @{
        EditMode                      = "Vi"
        AddToHistoryHandler           = $historyFilter
        ShowToolTips                  = $true
        ExtraPromptLineCount          = $true
        HistoryNoDuplicates           = $true
        HistorySearchCursorMovesToEnd = $true
        MaximumHistoryCount           = 5000
        PredictionSource              = "HistoryAndPlugin"
        PredictionViewStyle           = "ListView"
        BellStyle                     = "None"
        Colors                        = @{
            Command   = '#87CEEB'  # SkyBlue (pastel)
            Parameter = '#98FB98'  # PaleGreen (pastel)
            Operator  = '#FFB6C1'  # LightPink (pastel)
            Variable  = '#DDA0DD'  # Plum (pastel)
            String    = '#FFDAB9'  # PeachPuff (pastel)
            Number    = '#B0E0E6'  # PowderBlue (pastel)
            Type      = '#F0E68C'  # Khaki (pastel)
            Comment   = '#D3D3D3'  # LightGray (pastel)
            Keyword   = '#8367c7'  # Violet (pastel)
            Error     = '#FF6347'  # Tomato (keeping it close to red for visibility)
    
        }
    }
    
    Set-PSReadLineOption @PSReadLineOptions

    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key "Alt+j" -Function ViCommandMode
    Set-PSReadLineKeyHandler -Key "Alt+d" -Function ShellKillWord
    Set-PSReadLineKeyHandler -Key "Alt+Backspace" -Function ShellBackwardKillWord
    Set-PSReadLineKeyHandler -Key "Alt+b" -Function ShellBackwardWord
    Set-PSReadLineKeyHandler -Key "Alt+e" -Function ShellForwardWord
    Set-PSReadLineKeyHandler -Key "Alt+B" -Function SelectShellBackwardWord
    Set-PSReadLineKeyHandler -Key "Alt+E" -Function SelectShellForwardWord
}

function setup {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    Initialize-Modules
    Initialize-Env
}

setup
