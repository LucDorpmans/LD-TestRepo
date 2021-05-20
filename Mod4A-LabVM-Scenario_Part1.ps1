$ErrorActionPreference = "stop"


#########################
# Run from Hyper-V Host #
#region########################

#region Initialization
# Verify Running as Admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
    Write-Host "-- Restarting as Administrator" -ForegroundColor Cyan ; Start-Sleep -Seconds 1
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
    exit
}

$ErrorActionPreference = "stop"

##Load LabConfig....
. ".\LabConfig.ps1"

#VM Credentials
$secpasswd = ConvertTo-SecureString $LabConfig.AdminPassword -AsPlainText -Force
$VMCreds = New-Object System.Management.Automation.PSCredential ("corp\$($LabConfig.DomainAdminName)", $secpasswd)

#Define VMM
$MgmtVM = Get-VM | Where-Object {$_.Name -like "$($labconfig.Prefix)*Management"}

#ask for parent vhdx for and VMs
if (Test-Path .\ParentDisks\WinServerCore.vhdx) {
    $VHDPath = (get-item .\ParentDisks\WinServerCore.vhdx).FullName
    $VHDName = (get-item .\ParentDisks\WinServerCore.vhdx).Name
}
else {
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms")
    $openFile = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        Title = "Please select parent VHDx for SDN VMs (2016 or RS3)." # You can copy it from parentdisks on the Hyper-V hosts somewhere into the lab and then browse for it"
    }
    $openFile.Filter = "VHDx files (*.vhdx)|*.vhdx" 
    If ($openFile.ShowDialog() -eq "OK") {
        Write-Host  "File $($openfile.FileName) selected" -ForegroundColor Cyan
    } 
    if (!$openFile.FileName) {
        Write-Host "No VHD was selected... Skipping VM Creation" -ForegroundColor Red
    }
    $VHDPath = $openFile.FileName
    $VHDName = $openfile.SafeFileName
}

#ask for fabric config file
[reflection.assembly]::loadwithpartialname("System.Windows.Forms")
$confopenFile = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Title = "Please select the MultiNodeConfig.psd1 file." # You can copy it from parentdisks on the Hyper-V hosts somewhere into the lab and then browse for it"
}
$confopenFile.Filter = "PSD1 files (*.psd1)|*.psd1" 
If ($confopenFile.ShowDialog() -eq "OK") {
    Write-Host  "File $($confopenFile.FileName) selected" -ForegroundColor Cyan
} 
if (!$openFile.FileName) {
    Write-error -Message  "no files found"
}
$confFilePath = $confopenFile.FileName

#ask for WAC
[reflection.assembly]::loadwithpartialname("System.Windows.Forms")
$openFile = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    Title = "Please select Windows Admin Center MSI" 
}
$openFile.Filter = "Msi files (*.msi)|*.msi" 
If ($openFile.ShowDialog() -eq "OK") {
    Write-Host  "File $($openfile.FileName) selected" -ForegroundColor Cyan
} 
if (!$openFile.FileName) {
    Write-Error "File not found for Windows Admin Center!"
}
$WACPath = $openFile.FileName
$WACName = $openfile.SafeFileName
#>

#grab SDN from git
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/Microsoft/SDN/archive/master.zip" -OutFile .\SDN-Master.zip
Unblock-File -Path .\SDN-Master.zip
#grab Chrome
Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile .\chrome_installer.exe
Unblock-File -Path .\chrome_installer.exe
#endregion

#region Start VMs 
Write-host "Starting VMs" -foregroundcolor Green
Get-VM | Where-Object {$_.Name -like "$($labconfig.Prefix)*"} | Start-VM
#endregion Start VMs 

#wait for management VM
Write-Host "Waiting for PSDirect to $($VM.VMName) for $($VMCreds.UserName)"
$startTime = Get-Date
do {
    $timeElapsed = $(Get-Date) - $startTime
    if ($($timeElapsed).TotalMinutes -ge 10) {
        Write-Host "Could not connect to PS Direct after 10 minutes"
        throw
    } 
    Start-Sleep -sec 5
    $psReady = Invoke-Command -VMId $MgmtVM.VMId -Credential $VMCreds `
        -ScriptBlock { $True } -ErrorAction SilentlyContinue
} 
until ($psReady)

$MgmtVM | Copy-VMFile -SourcePath $VHDPath -FileSource Host -DestinationPath "C:\Library\WScore_Master.vhdx" -Force -CreateFullPath
$MgmtVM | Copy-VMFile -SourcePath $confFilePath -DestinationPath "C:\Library\MultiNodeConfig.psd1" -CreateFullPath -FileSource Host -Force
$MgmtVM | Copy-VMFile -SourcePath $WACPath -DestinationPath "C:\Library\WindowsAdminCenter.msi" -CreateFullPath -FileSource Host -Force
$MgmtVM | Copy-VMFile -SourcePath .\SDN-Master.zip -DestinationPath "C:\SDN-Master.zip" -CreateFullPath -FileSource Host -Force
$MgmtVM | Copy-VMFile -SourcePath .\chrome_installer.exe -DestinationPath "C:\Library\chrome_installer.exe" -CreateFullPath -FileSource Host -Force

#
Write-host "Add windows features to $($MgmtVM.Name)" -foregroundcolor Green
Invoke-Command -VMId $MgmtVM.Id -ScriptBlock {  
    Get-WindowsFeature *rsat* | Install-WindowsFeature
    Restart-Computer -Force
} -Credential $VMCreds

Write-Host "#------------ Done configuring VMs, Continue on $($MgmtVM.Name) ------------#" -foregroundcolor Yellow
Write-Host "#---------------------------------------------------------------------------#" -foregroundcolor Yellow
throw

#######################################
# ENDING Run from Hyper-V Host ENDING #
#endregion######################################
