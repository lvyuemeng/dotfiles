# For preparation of chezmoi init only
# installation of rage
#
if (Get-Command "rage" -ErrorAction SilentlyContinue) {
	Write-Output "rage installed."
	exit 0
} 

Invoke-WebRequest "https://gh-proxy.com/https://raw.githubusercontent.com/lvyuemeng/scoop-cn/master/installer.ps1" | Invoke-Expression
& scoop install spc/rage

Write-Host "rage installed."