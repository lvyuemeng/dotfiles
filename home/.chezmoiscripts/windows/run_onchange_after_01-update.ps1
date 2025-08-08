# Go template use a **reference date** to represent format.
# {{ now | date "2006-01-02" }}
Write-Host "updating scoop manifests..."

& scoop export >> $HOME/.config/scoop/manifest.json

Write-Host "done."