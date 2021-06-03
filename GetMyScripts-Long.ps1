# GetMyScripts-Long.ps1
Function Get-MyScript 
{    [CmdletBinding()]
    Param    ( 
        [Parameter(Mandatory=$true,Position=0)]
        [string]$AFile,
        [string]$SaveLocation = "$env:USERPROFILE\Downloads\", 
		[switch]$EditFile = $False )
        Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$AFile"  -Outfile "$SaveLocation$AFile" 
		If ($EditFile) { PSEdit  ("$SaveLocation$AFile" )} }

Get-MyScript "EdgeMSI-DownloadComplete.ps1"
Get-MyScript "Edge-InstallOnly.ps1"
Get-MyScript "Download+Install+PowerShell-Core.ps1" -EditFile
Get-MyScript "WAC-Download+Install.ps1"
Get-MyScript "Chrome-Download+Run-Installer.ps1"
