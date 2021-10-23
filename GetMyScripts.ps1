# GetMyScripts.ps1
Function Get-MyScript { Param( [string]$AFile,[switch]$EditFile = $False, 
							   [string]$SPath = "$env:USERPROFILE\Downloads\")
			Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$AFile"  -Outfile "$SPath$AFile" 
			If ($EditFile) { PSEdit  ("$SPath$AFile" )} }
		
Get-MyScript "EdgeMSI-Download-Only-Complete.ps1" -EditFile
Get-MyScript "Edge-InstallOnly.ps1" -EditFile
Get-MyScript "Chrome-Download+Run-Installer.ps1" -EditFile
Get-MyScript "PowerShell-Core-Download+Install.ps1"
Get-MyScript "VSCode-Download+Install.ps1"
Get-MyScript "WAC-Download+Install.ps1"
