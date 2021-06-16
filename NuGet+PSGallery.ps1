#[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Install-PackageProvider nuget -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module xPSDesiredStateConfiguration -Verbose -Repository PSGallery

# Get-DscResource
