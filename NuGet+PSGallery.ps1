# Unattended install of NuGet repository, and set PSGallery to be a Trusted repository
$OrgVerbosePreference = $VerbosePreference 
$VerbosePreference = "Continue"

$Res = Get-PackageProvider NuGet -EA SilentlyContinue$Res 
If ($Null -eq $Res) { 
    Write-Verbose "Not installed, installing"
    Install-PackageProvider nuget -Force 
}
$NuProv = Get-PackageProvider -Name Nuget
Write-Verbose "NuGet PackageProvider version $($NuProv.Version) installed" 

If ( (Get-PSRepository PSGallery).InstallationPolicy -eq "Trusted" )  {
    Write-Verbose "PsGallery already trusted" } 
Else { 
    Write-Verbose "{PsGallery not yet trusted, trying to approve"
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
 }

 $VerbosePreference = $OrgVerbosePreference 
