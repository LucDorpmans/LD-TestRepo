#[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" # For older Windows versions
If (!(Get-PackageProvider -Name Nuget)) { Install-PackageProvider nuget -Force } 
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Find-Module xDSC*
# Install-Module xPSDesiredStateConfiguration -Verbose -Repository PSGallery
Install-Module xDscDiagnostics -Verbose -Repository PSGallery

# Get-DscResource

If (!(Get-PackageProvider -Name Nuget)) {Write-Output "Yes"} else {Write-Output "No"}

$NuProv = Get-PackageProvider -Name Nuget
$NuProv.Version


