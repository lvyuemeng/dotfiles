Write-Host "updating scoop manifests..."

& scoop export >> $HOME/.config/scoop/manifest.json

Write-Host "done."