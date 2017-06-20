# Download UmbacoCms zip package and copy to app folder

$UmbracoCmsVersion = "7.6.3"
$DownloadUrl = "http://umbracoreleases.blob.core.windows.net/download/UmbracoCms.$UmbracoCmsVersion.zip"
$BuilderFolder = "C:\.build"
$UmbracoCmsZip = "UmbracoCms.zip"
$BackUpPath = "$BuilderFolder\$UmbracoCmsZip"
$Destination = "C:\app" # TODO pass this in as a parameter

New-Item -Path $BuilderFolder -ItemType Directory -Force | Out-Null

Write-Verbose -Message "Downloading Umbraco CMS - $DownloadUrl"
Invoke-WebRequest -Uri $DownloadUrl -OutFile $BackUpPath 

Write-Verbose -Message "Preparing Umbraco CMS folder - $Destination"
New-Item -Path $Destination -ItemType Directory -Force | Out-Null

Write-Verbose -Message "Unzipping Umbraco CMS to folder - $Destination"
Add-Type -assembly 'system.io.compression.filesystem'
[io.compression.zipfile]::ExtractToDirectory( (Resolve-Path $BackupPath), (Resolve-Path $Destination) )

Write-Information -MessageData "Umbraco CMS version $UmbracoCmsVersion installed in '$Destination' folder"