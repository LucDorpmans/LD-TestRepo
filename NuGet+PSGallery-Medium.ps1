#[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" # For older Windows versions

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$Res = Get-PackageProvider NuGet -EA SilentlyContinue 
If ($Null -eq $Res) { Install-PackageProvider nuget -Force } 

$NuProv = Get-PackageProvider -Name Nuget
$NuProv.Version

