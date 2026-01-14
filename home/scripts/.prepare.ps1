# For preparation of chezmoi init only
# installation of rage
#
if (Get-Command "rage" -ErrorAction SilentlyContinue) {
	Write-Output "rage installed."
	exit 0
} 

& ([scriptblock]::Create((Invoke-RestMethod "https://codeberg.org/nostalgia/SysKit-Win/raw/branch/master/scoop-install.ps1"))) -Source proxy
& scoop install spc/rage

Write-Host "rage installed."