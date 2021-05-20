Get-ChildItem -Path F:\WSLab-master\ -File -Recurse | Unblock-File

Set-Location -Path F:\WSLab-master\Scripts

Move-Item -Path '.\LabConfig.ps1' -Destination '.\LabConfig.m4l0.ps1' -Force -ErrorAction SilentlyContinue
Move-Item -Path '.\Scenario.ps1' -Destination '.\Scenario.m4l0.ps1' -Force -ErrorAction SilentlyContinue


# Past Labconfig commands in other  tab and save as F:\WSLab-master\Scripts\LabConfig.ps1

Copy-Item -Path 'F:\WSLab-master\Scenarios\SDNExpress with Windows Admin Center\Scenario.ps1' -Destination '.\'
Copy-Item -Path 'F:\WSLab-master\Scenarios\SDNExpress with Windows Admin Center\MultiNodeConfig.psd1' -Destination '.\'

# In the Administrator: Windows PowerShell ISE window open and run the F:\WSLab-master\Scripts\3_Deploy.ps1 script to provision VMs for the SDN environment.
PSEdit F:\WSLab-master\Scripts\3_Deploy.ps1 

# In the Administrator: Windows PowerShell ISE window, open the F:\WSLab-master\Scripts\Scenario.ps1 script, 
# remove all content following the line 128, starting from # ENDING Run from Hyper-V Host ENDING #, 
# and then save the modified file as Scenario_Part1.ps1.
PSEdit  F:\WSLab-master\Scripts\Scenario.ps1

# Ignore the error following the line ScriptHalted and message prompting to restart SDNExpress2019-Management. That's expected.

# After the script completes, in the Administrator: Windows PowerShell ISE window, open a new tab,
# and run the following script to expand the size of the disks hosting drive C of the newly provisioned VMs 
# that will host the SDN environment:

$servers = @('SDNExpress2019-HV1','SDNExpress2019-HV2','SDNExpress2019-HV3','SDNExpress2019-HV4')
$paths = (Get-VM -Name $servers | Get-VMHardDiskDrive | Where-Object {$_.ControllerLocation -eq 0} | Select-Object Path).Path
foreach ($path in $paths) { Resize-VHD -Path $path -SizeBytes 100GB }

>[!note] Sign in to the **DC** VM using the +++CORP\\LabAdmin+++ username and +++LS1setup!+++ password, run `slmgr -rearm` and restart it.


New-Item F:\Allfiles -itemtype directory -Force
Invoke-Webrequest -Uri "https://raw.githubusercontent.com/MicrosoftLearning/WS-013T00-Azure-Stack-HCI/master/Allfiles/SDNExpressModule.psm1" -Outfile "F:\Allfiles\SDNExpressModule.psm1"

