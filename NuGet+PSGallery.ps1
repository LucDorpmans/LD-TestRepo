# Unattended install of NuGet repository, and set PSGallery to be a Trusted repository
$OrgVerbosePreference = $VerbosePreference 
$VerbosePreference = "Continue"

If ((Get-PackageProvider -Name PowerShellGet -ListAvailable)) {
    $NuProv = Get-PackageProvider -Name Nuget
    Write-Verbose "NuGet PackageProvider version $($NuProv.Version) installed" 
} 
Else {
    Write-Verbose "Not installed, installing"
    { Install-PackageProvider nuget -Force } 
    Write-Verbose "Installed  (if no errors)"
}


If ( (Get-PSRepository PSGallery).InstallationPolicy -eq "Trusted" )  {
    Write-Verbose "PsGallery already trusted" } 
Else { 
    Write-Verbose "{PsGallery not yet trusted, trying to approve"
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
 }

 $VerbosePreference = $OrgVerbosePreference 