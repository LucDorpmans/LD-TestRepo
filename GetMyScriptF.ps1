#GetMyScriptF.ps1
Function Get-MyScript 
{    [CmdletBinding()]
    Param    ( 
        [Parameter(Mandatory=$true,Position=0)]
        [string]$AFile,
        [string]$SaveLocation = "$env:USERPROFILE\Downloads\"     )
        Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$AFile"  -Outfile "$SaveLocation$AFile"
        PSEdit "$SaveLocation$AFile"}

Get-MyScript "EdgeMSI-DownloadComplete.ps1"
Get-MyScript "Chrome-Download+Run-Installer.ps1"
Get-MyScript "WAC-Download+Install.ps1"

<# Module 4:
Get-MyScript Mod4A-LabVM-Instructions.ps1
Get-MyScript Mod4A-LabVM-LabConfig.ps1
Get-MyScript Mod4A-LabVM-Scenario_Part1.ps1

Get-MyScript Mod4A-Mgmt-MultiNodeConfig.psd1
Get-MyScript Mod4A-Mgmt-SDNExpress.ps1
Get-MyScript Mod4A-Mgmt-Scenario_Part2.ps1
#>
