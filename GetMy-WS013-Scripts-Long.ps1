# GetMy-WS013-Scripts-Long.ps1
Function Get-MyScript 
{    [CmdletBinding()]
    Param    ( 
        [Parameter(Mandatory=$true,Position=0)]
        [string]$AFile,
        [string]$SaveLocation = "$env:USERPROFILE\Downloads\", 
		[switch]$EditFile = $False )
        Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/My-WS-013-Repo/main/$AFile"  -Outfile "$SaveLocation$AFile" 
		If ($EditFile) { PSEdit  ("$SaveLocation$AFile" )} }

Get-MyScript "Chrome-Download+Run-Installer.ps1" -EditFile
Get-MyScript "WAC-Download+Install.ps1" -EditFile
Get-MyScript "EdgeMSI-Download-Only-Complete.ps1" -EditFile
Get-MyScript "Edge-InstallOnly.ps1"
