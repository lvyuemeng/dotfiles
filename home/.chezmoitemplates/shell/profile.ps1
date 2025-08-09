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
    # vfox
    Invoke-Expression "$(vfox activate pwsh)"
    # starship
    Invoke-Expression (&starship init powershell)

    $ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
    $ENV:EDITOR = "code.cmd"
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
        $ignore_psreadline = @("user", "pass", "account")
        foreach ($ignore in $ignore_psreadline) {
            if ($line -match $ignore) {
                return $false
            }
        }
        return $true
    }

    $PSReadLineOptions = @{
        EditMode             = "Vi"
        AddToHistoryHandler  = $historyFilter
        ExtraPromptLineCount = $true
        HistoryNoDuplicates  = $true
        MaximumHistoryCount  = 5000
        PredictionSource     = "HistoryAndPlugin"
        PredictionViewStyle  = "ListView"
        ShowToolTips         = $true
        BellStyle            = "None"
    }

    Set-PSReadLineKeyHandler -Key "Ctrl+j" -Function ViCommandMode
    Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
    Set-PSReadLineKeyHandler -Key "Ctrl+LeftArrow" -Function BackwardWord
}

function setup {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    Initialize-Modules
    Initialize-Env
}

setup
