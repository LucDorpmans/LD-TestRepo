$progressPreference='SilentlyContinue'
$MyFile = "PowerShell-7.1.3-win-x64.msi"
Invoke-Webrequest -Uri "https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/PowerShell-7.1.4-win-x64.msi"  -Outfile "$env:USERPROFILE\Downloads\$MyFile"
Get-ChildItem "$env:USERPROFILE\Downloads\$MyFile"
Write-Output "Starting installation of $MyFile"
Start-Process msiexec.exe -Wait -ArgumentList "/i $env:USERPROFILE\Downloads\$MyFile /qn /quiet"
