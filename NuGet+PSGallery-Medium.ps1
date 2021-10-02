#[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" # For older Windows versions

$Res = Get-PackageProvider NuGetX -EA SilentlyContinue$Res 
If ($Null -eq $Res) { Install-PackageProvider nuget -Force } 

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$NuProv = Get-PackageProvider -Name Nuget
$NuProv.Version

