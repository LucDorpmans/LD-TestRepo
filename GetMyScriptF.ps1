#GetMyScriptF.ps1
Function Get-MyScript 
{    [CmdletBinding()]
    Param    ( 
        [Parameter(Mandatory=$true,Position=0)]
        [string]$AFile,
        [string]$SaveLocation = "$env:USERPROFILE\Downloads\"     )
        Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$AFile"  -Outfile "$SaveLocation$AFile" }

Get-MyScript "Chrome-Download+Run-Installer.ps1"
Get-MyScript "WAC-Download+Install.ps1"
Get-MyScript "EdgeMSI-Download-Only-Complete.ps1"
Get-MyScript "Edge-InstallOnly.ps1"

