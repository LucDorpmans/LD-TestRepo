# Mod 3
# Management VM
# Lab 3D
# Ex 1
# Task 2
Install-WindowsFeature -Name RSAT-Clustering,RSAT-Clustering-Mgmt,RSAT-Clustering-PowerShell,RSAT-Hyper-V-Tools,RSAT-AD-PowerShell,RSAT-ADDS

# Install chrome:
$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

# Install WAC:
Invoke-WebRequest -UseBasicParsing -Uri https://aka.ms/WACDownload -OutFile "$env:USERPROFILE\Downloads\WindowsAdminCenter.msi"
Start-Process msiexec.exe -Wait -ArgumentList "/i $env:USERPROFILE\Downloads\WindowsAdminCenter.msi /qn /L*v waclog.txt REGISTRY_REDIRECT_PORT_80=1 SME_PORT=443 SSL_CERTIFICATE_OPTION=generate"


# Step 9
$gateway = "Management"
$nodes = Get-ADComputer -Filter * -SearchBase "ou=workshop,DC=corp,dc=contoso,DC=com"
$gatewayObject = Get-ADComputer -Identity $gateway
    foreach ($node in $nodes){
Set-ADComputer -Identity $node -PrincipalsAllowedToDelegateToAccount $gatewayObject
}


# Task 3:

$servers = 1..6 | % {"S2D$_"}
$clusterName = "S2D-Cluster"
$clusterIP = "10.0.0.111"

# Install features on servers
Invoke-Command -computername $servers -ScriptBlock {
   Install-WindowsFeature -Name "Failover-Clustering","Hyper-V-PowerShell","RSAT-Clustering-PowerShell"
   }

# Restart servers since failover clustering in Windows Server 2019 requires reboot
Restart-Computer -ComputerName $servers -Protocol WSMan -Wait -For PowerShell

# Create cluster
New-Cluster -Name $clusterName -Node $servers -StaticAddress $clusterIP
Start-Sleep 5
Clear-DNSClientCache

# Add File Share Witness
# Create a new directory
$witnessName = $clusterName+"Witness"
Invoke-Command -ComputerName DC -ScriptBlock {New-Item -Path c:\Shares -Name $using:WitnessName -ItemType Directory}
$accounts = @()
$accounts += "CORP\$($clusterName)$"
$accounts += "CORP\Domain Admins"
New-SmbShare -Name $witnessName -Path "c:\Shares\$witnessName" -FullAccess $accounts -CimSession DC -ErrorAction SilentlyContinue
# Set NTFS permissions
Invoke-Command -ComputerName DC -ScriptBlock {(Get-SmbShare $using:witnessName).PresetPathAcl | Set-Acl}
# Set Quorum
Set-ClusterQuorum -Cluster $clusterName -FileShareWitness "\\DC\$witnessName"

# Task 4:
# Step 1"
$clusterName = "S2D-Cluster"

# Create Fault domains with PowerShell
New-ClusterFaultDomain -Name "Rack01" -FaultDomainType Rack -Location "Contoso HQ, Room 4010, Aisle A, Rack 01" -CimSession $clusterName
New-ClusterFaultDomain -Name "Rack02" -FaultDomainType Rack -Location "Contoso HQ, Room 4010, Aisle A, Rack 02" -CimSession $clusterName
New-ClusterFaultDomain -Name "Rack03" -FaultDomainType Rack -Location "Contoso HQ, Room 4010, Aisle A, Rack 03" -CimSession $clusterName

# Assign fault domains
# Assign nodes to racks
1..2 |ForEach-Object {Set-ClusterFaultDomain -Name "S2D$_" -Parent "Rack01" -CimSession $clusterName}
3..4 |ForEach-Object {Set-ClusterFaultDomain -Name "S2D$_" -Parent "Rack02" -CimSession $clusterName}
5..6 |ForEach-Object {Set-ClusterFaultDomain -Name "S2D$_" -Parent "Rack03" -CimSession $clusterName}

# Step 2:
$clusterName = "S2D-Cluster"
Get-ClusterFaultDomain -CimSession $clusterName
Get-ClusterFaultDomainxml -CimSession $clusterName

# Task 5:
# Step 1:
$clusterName = "S2D-Cluster"
Enable-ClusterS2D -CimSession $clusterName -Verbose

# Task 6:
# Step 1:
$clusterName = "S2D-Cluster"
Get-StoragePool -CimSession $clusterName -FriendlyName S2D* | fl *

# Step 2:
Get-StorageTier -CimSession s2d-cluster | fl *

# Task 7:
# Step 1:
New-Volume -StoragePoolFriendlyName s2d* -FriendlyName WithTier -FileSystem CSVFS_ReFS -StorageTierFriendlyNames Capacity -StorageTierSizes 1TB -CimSession $clusterName

# Step 2:
New-Volume -StoragePoolFriendlyName s2d* -FriendlyName WithoutTier -FileSystem CSVFS_ReFS -Size 1TB -ResiliencySettingName Mirror -CimSession $clusterName

# Task 9:
# Step 2:
Get-StorageSubSystem -CimSession s2d-cluster -FriendlyName CL* | Get-StorageJob

# Step 6:
Get-HealthFault -CimSession s2d-cluster
