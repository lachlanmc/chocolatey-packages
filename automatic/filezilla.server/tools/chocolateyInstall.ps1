try {
  $version = '{{PackageVersion}}'
  $version = $version.replace('.','_')
  $toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
  $processor = Get-WmiObject Win32_Processor
  $is64bit = $processor.AddressWidth -eq 64

  $progFiles = [System.Environment]::GetFolderPath('ProgramFiles')
  if ($is64bit -and $progFiles -notmatch 'x86') {$progFiles = "$progFiles (x86)"}
  $fileZillaInstallDir = Join-Path $progFiles "FileZilla Server"
  $tempDir = "C:\temp\ftproot"

  write-host "Chocolatey is installing FileZilla Server to $fileZillaInstallDir. The port is 14147, the user name/pass is filezilla/filezilla. The local ftp root folder is $tempDir."
  write-host "Please wait..."
  Start-sleep 8

  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  if (![System.IO.Directory]::Exists($fileZillaInstallDir)) {[System.IO.Directory]::CreateDirectory($fileZillaInstallDir)}

  if (![System.IO.File]::Exists("$($fileZillaInstallDir)\FileZilla Server Interface.xml")) {
    Write-Host "Copying FileZilla Server Interface.xml to install directory"
    Copy-Item "$($toolsDir)\FileZilla Server Interface.xml" "$fileZillaInstallDir" -Force
  }

  if (![System.IO.File]::Exists("$($fileZillaInstallDir)\FileZilla Server.xml")) {
    Write-Host "Copying FileZilla Server.xml to install directory"
    Copy-Item "$($toolsDir)\FileZilla Server.xml" "$fileZillaInstallDir" -Force
  }
    #moved to https://dl4.cdn.filezilla-project.org/server/FileZilla_Server-0_9_60_2.exe?h=Zox8x5Pt7bz2Pcyuy1KXmA&x=1545186963
    Install-ChocolateyPackage 'filezilla.server' 'exe' '/S' "https://dl4.cdn.filezilla-project.org/server/FileZilla_Server-$version.exe?h=Zox8x5Pt7bz2Pcyuy1KXmA&x=1545186963"

  Write-ChocolateySuccess 'filezilla.server'
} catch {
  Write-ChocolateyFailure 'filezilla.server' "$($_.Exception.Message)"
  throw
}

