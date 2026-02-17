# Go template use the reference date to represent format.
#
# {{ now | date "2006-01-02" }}
Write-Host "updating scoop manifests..."

# Export installed packages to ~/.config/scoop/export.json and ~/.config/winget/export.json
& scoop export > $HOME/.config/scoop/export.json
& winget export -o $HOME/.config/winget/export.json

Write-Host "done."