# Download and install VSCode
Invoke-Webrequest -Uri "https://raw.githubusercontent.com/PowerShell/vscode-powershell/master/scripts/Install-VSCode.ps1" -Outfile "$env:USERPROFILE\Downloads\Install-VSCode.ps1"
PSEdit  ("$env:USERPROFILE\Downloads\Install-VSCode.ps1")
