# For preparation of chezmoi init only
# installation of rage
#
if (Get-Command "rage" -ErrorAction SilentlyContinue) {
	Write-Output "rage installed."
	exit 0
} 

if (Get-Command "scoop" -ErrorAction SilentlyContinue) {
	Write-Output "installing rage by scoop..."
	# Set bucket mirror
	& scoop bucket add easy-win "https://gitee.com/easy-win/scoop-mirror"
	& scoop install easy-win/rage

	Write-Host "rage installed."
	exit 0
} 

Write-Output "Installing scoop..."

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

Invoke-WebRequest https://ghfast.top/raw.githubusercontent.com/lzwme/scoop-proxy-cn/main/install.ps1 | Invoke-Expression

# Set repo/bucker mirror
& scoop config SCOOP_REPO "https://gitee.com/scoop-installer/scoop"
& scoop bucket add easy-win "https://gitee.com/easy-win/scoop-mirror"
& scoop install easy-win/rage

Write-Host "rage installed."