#[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" # For older Windows versions
Install-PackageProvider nuget -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-PackageProvider -Name Nuget
