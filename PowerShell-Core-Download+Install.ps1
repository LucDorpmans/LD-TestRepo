$progressPreference='SilentlyContinue'
$MyFile = "PowerShell-7.2.1-win-x64.msi"
Invoke-Webrequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/PowerShell-7.2.1-win-x64.msi"  -Outfile "$env:USERPROFILE\Downloads\$MyFile"
Get-ChildItem "$env:USERPROFILE\Downloads\$MyFile"
Write-Output "Starting installation of $MyFile"
Start-Process msiexec.exe -Wait -ArgumentList "/i $env:USERPROFILE\Downloads\$MyFile /qn /quiet"
