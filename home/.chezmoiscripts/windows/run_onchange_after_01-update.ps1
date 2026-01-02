# Go template use the reference date to represent format.
#
# {{ now | date "2006-01-02" }}
Write-Host "updating scoop manifests..."

# overwrite >
& scoop export > $HOME/.scoop_man.json
& winget export -o $HOME/.winget_man.json

Write-Host "done."