#GetMyScriptF.ps1
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

    Process
    {
        Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$AFile"  -Outfile "$SaveLocation$AFile"
    }
}


Get-MyScript "EdgeMSI-DownloadComplete.ps1"

Get-MyScript "Chrome-Download+Run-Installer.ps1"

Get-MyScript  "WAC-Download+Install.ps1"

