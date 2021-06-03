# GetMyScripts.ps1
Function Get-MyScript { Param( [string]$AFile,[switch]$EditFile = $False, 
							   [string]$SPath = "$env:USERPROFILE\Downloads\")
			Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$AFile"  -Outfile "$SPath$AFile" }

Get-MyScript "EdgeMSI-Download-Only-Complete.ps1"
Get-MyScript "Edge-InstallOnly.ps1"
Get-MyScript "Download+Install+PowerShell-Core.ps1" -EditFile
Get-MyScript "WAC-Download+Install.ps1"
Get-MyScript "Chrome-Download+Run-Installer.ps1"
