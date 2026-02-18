# Install Nerd Fonts
# Downloads fonts directly from GitHub releases

$fonts = @("0xProto")

Write-Host "Installing Nerd Fonts..."

# Font directory
$fontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
if (-not (Test-Path $fontDir)) {
    New-Item -ItemType Directory -Path $fontDir -Force | Out-Null
}

# Check if already installed
$existingFonts = Get-ChildItem $fontDir -Filter "*.ttf" -ErrorAction SilentlyContinue
$allInstalled = $true
foreach ($font in $fonts) {
    if ($existingFonts.Name -like "*$font*") {
        Write-Host "  $font already installed"
    } else {
        $allInstalled = $false
    }
}

if ($allInstalled) {
    Write-Host "All fonts already installed"
    exit 0
}

# Install each font
foreach ($font in $fonts) {
    Write-Host "Installing $font..."
    
    # Download URL
    $url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip"
    $zipPath = "$env:TEMP\$font.zip"
    $extractPath = "$env:TEMP\$font"
    
    try {
        # Download
        Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing
        
        # Extract
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
        
        # Copy font files
        Get-ChildItem $extractPath -Recurse -Include "*.ttf", "*.otf" | Copy-Item -Destination $fontDir
        
        Write-Host "  ✓ $font installed"
    }
    catch {
        Write-Host "  ✗ Failed to install $font : $_"
    }
    finally {
        # Cleanup
        Remove-Item $zipPath -ErrorAction SilentlyContinue
        Remove-Item $extractPath -Recurse -ErrorAction SilentlyContinue
    }
}

Write-Host "Font installation complete."