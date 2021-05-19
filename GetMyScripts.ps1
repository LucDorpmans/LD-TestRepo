#GetMyScripts.ps1
$MyFile = "EdgeMSI-DownloadComplete.ps1"
Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$MyFile"  -Outfile "$env:USERPROFILE\Downloads\$MyFile" 

$MyFile = "Chrome-Download+RunInstaller.ps1"
Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$MyFile"  -Outfile "$env:USERPROFILE\Downloads\$MyFile"

$MyFile = "WAC-Download+Install.ps1"
Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/TestRepo/main/$MyFile"  -Outfile "$env:USERPROFILE\Downloads\$MyFile"

