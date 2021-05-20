#GetMyScriptF.ps1

<#
.Synopsis
   Get A Script from My GitHub Repository
.DESCRIPTION
   Get A Script from My GitHub Repository
.EXAMPLE
   Get-MyScript
.EXAMPLE
   Another example of how to use this cmdlet
#>
Function Get-MyScript 
{
    [CmdletBinding()]
    Param
    (
        # Filename of script to download
        [Parameter(Mandatory=$true,
                   Position=0)]
        [string]$AFile,

        # Location to save file, default is in the download folder of current user
        [string]
        $SaveLocation = "$env:USERPROFILE\Downloads\"
    )

    Begin
    {
    }
    Process
    {
        Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$AFile"  -Outfile "$SaveLocation$AFile"
    }
    End
    {
    }
}


Get-MyScript "EdgeMSI-DownloadComplete.ps1"

Get-MyScript "Chrome-Download+Run-Installer.ps1"

Get-MyScript  "WAC-Download+Install.ps1"

