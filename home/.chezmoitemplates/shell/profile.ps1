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

function Set-ToolAlias {
    # Global aliases
    Set-Alias -Name e -Value explorer.exe -Scope Global
}

# == ENVIRONMENT ==

function Initialize-Env {
    # oh-my-posh
    # oh-my-posh init pwsh --config "https://fastly.jsdelivr.net/gh/Weidows-projects/Programming-Configuration@master/others/pwsh/weidows.omp.json" | Invoke-Expression
    # fnm
    # fnm env --use-on-cd | Out-String | Invoke-Expression
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
        if ($Handler) {
            & $Handler
        }
        else {
            Install-Module -Name $moduleName -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck
        }
    }
    try {
        Import-Module $moduleName -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to import ${moduleName}: $_"
    }

}

function Get-ColorTheme {
    $Theme = "Catppuccin"

    if (-not(Get-Module -ListAvailable -Name $Theme)) {
        return @{}
    }
    
    Import-Module -Name $Theme -Force

    $Flavor = $Catppuccin['Mocha']

    # Side affect
    # PSStyle colors
    $PSStyle.Formatting.Debug = $Flavor.Sky.Foreground()
    $PSStyle.Formatting.Error = $Flavor.Red.Foreground()
    $PSStyle.Formatting.ErrorAccent = $Flavor.Blue.Foreground()
    $PSStyle.Formatting.FormatAccent = $Flavor.Teal.Foreground()
    $PSStyle.Formatting.TableHeader = $Flavor.Rosewater.Foreground()
    $PSStyle.Formatting.Verbose = $Flavor.Yellow.Foreground()
    $PSStyle.Formatting.Warning = $Flavor.Peach.Foreground()


    # Ref: https://github.com/catppuccin/powershell#profile-usage
    $Colors = @{
        # Largely based on the Code Editor style guide
        # Emphasis, ListPrediction and ListPredictionSelected are inspired by the Catppuccin fzf theme

        # Powershell colours
        ContinuationPrompt     = $Flavor.Teal.Foreground()
        Emphasis               = $Flavor.Red.Foreground()
        Selection              = $Flavor.Surface0.Background()

        # PSReadLine prediction colours
        InlinePrediction       = $Flavor.Overlay0.Foreground()
        ListPrediction         = $Flavor.Mauve.Foreground()
        ListPredictionSelected = $Flavor.Surface0.Background()

        # Syntax highlighting
        Command                = $Flavor.Blue.Foreground()
        Comment                = $Flavor.Overlay0.Foreground()
        Default                = $Flavor.Text.Foreground()
        Error                  = $Flavor.Red.Foreground()
        Keyword                = $Flavor.Mauve.Foreground()
        Member                 = $Flavor.Rosewater.Foreground()
        Number                 = $Flavor.Peach.Foreground()
        Operator               = $Flavor.Sky.Foreground()
        Parameter              = $Flavor.Pink.Foreground()
        String                 = $Flavor.Green.Foreground()
        Type                   = $Flavor.Yellow.Foreground()
        Variable               = $Flavor.Lavender.Foreground()
    }
    
    return $Colors
}

function Initialize-Modules {
    $modules = @(
        "CompletionPredictor"
        "PsReadLine"
    )
    
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Warning "Beautification only support for Powershell with major version >= 7."
        return
    }

    foreach ($module in $modules) {
        Add-OwnModule -moduleName $module
    }
    
    # == Color Theme ==
    $Colors = Get-ColorTheme

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
        Color                = $Colors
        ExtraPromptLineCount = $true
        HistoryNoDuplicates  = $true
        MaximumHistoryCount  = 5000
        PredictionSource     = "HistoryAndPlugin"
        PredictionViewStyle  = "ListView"
        ShowToolTips         = $true
        BellStyle            = "None"
    }

    Set-PSReadLineOption @PSReadLineOptions
    # #  jj to exit insert mode
    # Set-PSReadLineKeyHandler -Chord 'j' -ScriptBlock {
    #     if ([Microsoft.PowerShell.PSConsoleReadLine]::InViInsertMode()) {
    #         $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    #         if ($key.Character -eq 'j') {
    #             [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
    #         }
    #         else {
    #             [Microsoft.Powershell.PSConsoleReadLine]::Insert('j')
    #             [Microsoft.Powershell.PSConsoleReadLine]::Insert($key.Character)
    #         }
    #     }
    # }
    Set-PSReadLineKeyHandler -Key "Ctrl+j" -Function ViCommandMode
    Set-PSReadLineKeyHandler -Key "Ctrl+p" -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key "Ctrl+n" -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key "Ctrl+b" -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
    Set-PSReadLineKeyHandler -Key "Ctrl+LeftArrow" -Function BackwardWord
}

function Setup {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    Initialize-Modules
    Initialize-Env
    Set-ToolAlias
}

Setup
