
# NOTE: If you are using PowerShell 7+, please run
# Import-Module Appx -UseWindowsPowerShell
# before using Add-AppxPackage.
https://github.com/microsoft/terminal/releases/download/v1.12.10982.0/Microsoft.WindowsTerminal_Win10_1.12.10982.0_8wekyb3d8bbwe.msixbundle

https://github.com/microsoft/terminal/releases

Add-AppxPackage Microsoft.WindowsTerminal_<versionNumber>.msixbundle

https://github.com/microsoft/terminal/releases

Invoke-Webrequest -Uri "https://github.com/microsoft/terminal/releases/download/v1.12.10982.0/Microsoft.WindowsTerminal_Win10_1.12.10982.0_8wekyb3d8bbwe.msixbundle" -Outfile "$env:USERPROFILE\Downloads\WindowsTerminal.msixbundle"

# Invoke-Webrequest -Uri "https://raw.githubusercontent.com/PowerShell/vscode-powershell/master/scripts/Install-VSCode.ps1" -Outfile "$env:USERPROFILE\Downloads\Install-VSCode.ps1"

Add-AppxPackage "$env:USERPROFILE\Downloads\WindowsTerminal.msixbundle"