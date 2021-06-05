# 1. On the Azure VM, open PowerShell ISE, copy the file IISConfig.ps1 to $DemoFolderFull\
$DemoFolderPath = "C:\"
$DemoFolder = "Demo"
$DemoFolderFull = "$DemoFolderPath$DemoFolder"

$SourceFolder = "$env:USERPROFILE\Documents"
$SourceFolder = "C:\PowerShellDSC"

New-Item -Name $DemoFolder -Path $DemoFolderPath -ItemType Directory 
Copy-Item $SourceFolder\IISConfig.ps1 -Destination $DemoFolderFull\IISConfig.ps1 -Force

PSEdit $DemoFolderFull\IISConfig.ps1 

# Prepare to download xWebAdministration without prompts
Install-PackageProvider nuget -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# 2. From the PowerShell ISE console pane, run the following command to install the xWebAdministration module:
Install-Module xWebAdministration -Verbose 
#    Note: When you receive a prompt to install NuGet provider, select Yes. When you receive a prompt to install the modules from PSGallery, select Yes to All.

# 3. Run the IISConfig script you copied into the script pane.
Invoke-Expression $DemoFolderFull\IISConfig.ps1 

#	 Note the message displayed in the script pane, and then verify that the $DemoFolderFull\IISConfig\localhost.mof file has been successfully created.
PSEdit $DemoFolderFull\IISConfig\localhost.mof

# 4. From the PowerShell ISE console pane, run the following in order to apply the DSC configuration.
Start-DscConfiguration -Path '$DemoFolderFull\IISConfig' -Wait -Verbose 
# 6. Wait until the configuration is applied, and then verify that it completed successfully.
# 7. From the Server Manager window, start Internet Information Services (IIS) Manager, and then in its console, verify that the Default Web Site is stopped.


Start-DscConfiguration -Path 'C:\Demo\IISConfigHardCoded' -Wait -Verbose -Force

Start-DscConfiguration -Path 'C:\Demo\IISCleanUp' -Wait -Verbose -Force

Start-DscConfiguration -Path 'C:\Demo\IISConfigDefault' -Wait -Verbose -Force

Start-DscConfiguration -Path 'C:\Demo\IISConfigDemoToo' -Wait -Verbose -Force

Start-DscConfiguration -Path 'C:\Demo\IISInstall' -Wait -Verbose -Force

$DSCConfig = 'IISRemove'
Start-DscConfiguration -Path "C:\Demo\$DSCConfig" -Wait -Verbose -Force

$DSCConfig = 'IISDemoConfig'
Start-DscConfiguration -Path "C:\Demo\$DSCConfig" -Wait -Verbose -Force


Get-Website

Get-ChildItem C:\Windows\System32\Configuration

Update-DscConfiguration

Remove-DscConfigurationDocument -Stage Current
Remove-DscConfigurationDocument -Stage Pending
Remove-DscConfigurationDocument -Stage Previous

Stop-DscConfiguration

Get-ChildItem C:\Windows\System32\Configuration

