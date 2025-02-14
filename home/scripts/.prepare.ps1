# For preparation of chezmoi init only
# installation of rage
#

if (Get-Command "rage" -ErrorAction SilentlyContinue) {
	Write-Output "rage is already installed"
	exit 0
} 

if (Get-Command "scoop" -ErrorAction SilentlyContinue) {
	Write-Output "Scoop is already installed, installing rage..."
	# Set bucket mirror
	& scoop bucket add easy-win https://gitee.com/easy-win/scoop-mirror
	& scoop install rage
	exit 0
} 

Write-Output "Scoop is not installed, installing scoop..."

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm scoop.201704.xyz -outfile 'install.ps1'
.\install.ps1

# Set repo/bucker mirror
& scoop config SCOOP_REPO "https://gitee.com/scoop-installer/scoop"
& scoop bucket add easy-win https://gitee.com/easy-win/scoop-mirror

Write-Output "Scoop installation complete, installing rage..."
& scoop install easy-win/rage

echo "rage installation complete!"