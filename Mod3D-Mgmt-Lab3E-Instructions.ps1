# Mod 3
# Management VM
# Lab 3E
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
$clusters=@()
$clusters+=@{Nodes=1..2 | % {"2T2node$_"} ; Name="2T2nodeClus" ; IP="10.0.0.112" }
$clusters+=@{Nodes=1..3 | % {"2T3node$_"} ; Name="2T3nodeClus" ; IP="10.0.0.113" }
$clusters+=@{Nodes=1..2 | % {"3T2node$_"} ; Name="3T2nodeClus" ; IP="10.0.0.115" }
$clusters+=@{Nodes=1..3 | % {"3T3node$_"} ; Name="3T3nodeClus" ; IP="10.0.0.116" }

# Install features on servers
Invoke-Command -computername $clusters.nodes -ScriptBlock {
 Install-WindowsFeature -Name "Failover-Clustering","Hyper-V-PowerShell","RSAT-Clustering-PowerShell" #RSAT is needed for Windows Admin Center
}

# Restart servers since failover clustering in Windows Server 2019 requires reboot
Restart-Computer -ComputerName $clusters.nodes -Protocol WSMan -Wait -For PowerShell

# Create clusters
foreach ($cluster in $clusters){
 New-Cluster -Name $cluster.Name -Node $cluster.Nodes -StaticAddress $cluster.IP
 Start-Sleep 5
 Clear-DNSClientCache
}

# Add file share witness
foreach ($cluster in $clusters){
 $clusterName = $cluster.Name
 # Create new directory
 $WitnessName = $clusterName+"Witness"
 Invoke-Command -ComputerName DC -ScriptBlock {New-Item -Path c:\Shares -Name $using:WitnessName -ItemType Directory}
 $accounts = @()
 $accounts += "CORP\$($clusterName)$"
 $accounts += "CORP\Domain Admins"
 New-SmbShare -Name $WitnessName -Path "c:\Shares\$WitnessName" -FullAccess $accounts -CimSession DC
 # Set NTFS permissions
 Invoke-Command -ComputerName DC -ScriptBlock {(Get-SmbShare $using:WitnessName).PresetPathAcl | Set-Acl}
 # Set Quorum
 Set-ClusterQuorum -Cluster $clusterName -FileShareWitness "\\DC\$WitnessName"
}

# Enable Storage Spaces Direct and configure mediatype to simulate 3 tier system with SCM (all 800GB disks are SCM, all 4T are SSDs)
foreach ($cluster in $clusters.Name){
 Enable-ClusterS2D -CimSession $cluster -Verbose -Confirm:0
 if ($cluster -like "3T*"){
   invoke-command -computername $cluster -scriptblock {
     Get-PhysicalDisk | Where-Object size -eq 800GB | Set-PhysicalDisk -MediaType SCM
     Get-PhysicalDisk | Where-Object size -eq 4TB | Set-PhysicalDisk -MediaType SSD
   }
 }
}


