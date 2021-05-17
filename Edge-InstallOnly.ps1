# Manually Download from https://www.microsoft.com/en-us/edge/business/download or run script Get-EdgeEnterpriseMSI.ps1 and save to downloads:

# Prevent First Run Experience afterinstall
New-Item HKLM:\SOFTWARE\Policies\Microsoft\Edge
New-ItemProperty -Name HideFirstRunExperience -Path HKLM:\SOFTWARE\Policies\Microsoft\Edge -Value 1

Write-Verbose "Starting installation of Microsoft Edge Enterprise" 
Start-Process msiexec.exe -Wait -ArgumentList "/i $env:USERPROFILE\Downloads\MicrosoftEdgeEnterpriseX64.msi /qn /quiet /norestart"
Write-Verbose "Finished installation of Microsoft Edge Enterprise" 