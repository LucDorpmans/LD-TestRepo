# GetMy-WS011-Files.ps1
Function Get-MyScript { Param( [string]$AFile,[switch]$EditFile = $False, 
							   [string]$SPath = "$env:USERPROFILE\Downloads\")
			Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/My-WS-011-Repo/main/$AFile"  -Outfile "$SPath$AFile" 
			If ($EditFile) { PSEdit ("$SPath$AFile" )} }


Get-MyScript "Chrome-Download+Run-Installer.ps1" -EditFile
Get-MyScript "WAC-Download+Install.ps1" -EditFile
Get-MyScript "EdgeMSI-Download-Only-Complete.ps1"
Get-MyScript "Edge-InstallOnly.ps1"

Function DownloadFilesFromRepo {
# https://gist.github.com/chrisbrownie/f20cb4508975fb7fb5da145d3d38024a
Param(
    [string]$Owner,
    [string]$Repository,
    [string]$Path,
    [string]$DestinationPath
    )

    $baseUri = "https://api.github.com/"
    $args = "repos/$Owner/$Repository/contents/$Path"
    $wr = Invoke-WebRequest -Uri $($baseuri+$args)
    $objects = $wr.Content | ConvertFrom-Json
    $files = $objects | where {$_.type -eq "file"} | Select -exp download_url
    $directories = $objects | where {$_.type -eq "dir"}
    
    $directories | ForEach-Object { 
        DownloadFilesFromRepo -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath $($DestinationPath+$_.name)
    }

    
    if (-not (Test-Path $DestinationPath)) {
        # Destination path does not exist, let's create it
        try {
            New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop
        } catch {
            throw "Could not create path '$DestinationPath'!"
        }
    }

    foreach ($file in $files) {
        $fileDestination = Join-Path $DestinationPath (Split-Path $file -Leaf)
        try {
            Invoke-WebRequest -Uri $file -OutFile $fileDestination -ErrorAction Stop -Verbose
            "Grabbed '$($file)' to '$fileDestination'"
        } catch {
            throw "Unable to download '$($file.path)'"
        }
    }

}


DownloadFilesFromRepo -Owner "LucDorpmans" -Repository My-WS-013-Repo -DestinationPath C:\Library\Github\

