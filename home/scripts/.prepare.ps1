# For preparation of chezmoi init only
# installation of rage
#
if (Get-Command "rage" -ErrorAction SilentlyContinue) {
	Write-Output "rage installed."
	exit 0
} 

& ([scriptblock]::Create((irm "https://gitee.com/nostalgiaLiquid/SysKit-Win/raw/main/scoop-tool.ps1"))) install -s proxy
& scoop install spc/rage

Write-Host "rage installed."