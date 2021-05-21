# Reference: https://docs.microsoft.com/en-us/azure/virtual-desktop/language-packs
# Download Language ISO, Feature on Demand (FOD) Disk 1, and Inbox Apps ISO for Windows 10 20H2
write-host 'AIB Customization: Download Language ISO, Feature on Demand (FOD) Disk 1, and Inbox Apps ISO for Windows 10 20H2'
$appName = 'languagePacks'
$drive = 'D:\'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + $appName
Set-Location $LocalPath
$langIsoUrl = 'https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso'
$langIsoUrlIso = 'ClientLangPack.iso'
$fodIsoUrl = 'https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_amd64fre_FOD-PACKAGES_OEM_PT1_amd64fre_MULTI.iso'
$fodIsoUrlIso = 'FOD.iso'
#$inboxAppsIsoUrl = 'https://software-download.microsoft.com/download/pr/19041.508.200905-1327.vb_release_svc_prod1_amd64fre_InboxApps.iso'
#$inboxAppsIsoUrlIso = 'InboxApps.iso'
$langOutputPath = $LocalPath + '\' + $langIsoUrlIso
$fodOutputPath = $LocalPath + '\' + $fodIsoUrlIso
#$inboxAppsOutputPath = $LocalPath + '\' + $inboxAppsIsoUrlIso
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $langIsoUrl -OutFile $langOutputPath
write-host 'AIB Customization: Finished Download for Language ISO for Windows 10 20H2'
Invoke-WebRequest -Uri $fodIsoUrl -OutFile $fodOutputPath
write-host 'AIB Customization: Finished Download for Feature on Demand (FOD) Disk 1 for Windows 10 20H2'
#Invoke-WebRequest -Uri $inboxAppsIsoUrl -OutFile $inboxAppsOutputPath
#write-host 'AIB Customization: Finished Download for Inbox Apps ISO for Windows 10 20H2'

# Mount ISOs
write-host 'AIB Customization: Mount ISOs'
$langMount = Mount-DiskImage -ImagePath $langOutputPath
$fodMount = Mount-DiskImage -ImagePath $fodOutputPath
#$inboxAppsMount = Mount-DiskImage -ImagePath $inboxAppsOutputPath

$langDrive = ($langMount | Get-Volume).DriveLetter+":"
$fodDrive = ($fodMount | Get-Volume).DriveLetter+":"
#$inboxAppsDrive = ($inboxAppsMount | Get-Volume).DriveLetter

$langPackPath = $langDrive+"\x64\langpacks"
write-host 'AIB Customization: Finished Mounting ISOs'

# Disable Language Pack Cleanup
write-host 'AIB Customization: Disabling language pack cleanup task'
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup"

# Spanish
write-host 'AIB Customization: Installing Spanish (Spain) language packs'
Add-AppProvisionedPackage -Online -PackagePath $langDrive\LocalExperiencePack\es-es\LanguageExperiencePack.es-ES.Neutral.appx -LicensePath $langDrive\LocalExperiencePack\es-es\License.xml

Add-WindowsPackage -Online -PackagePath $langPackPath\Microsoft-Windows-Client-Language-Pack_x64_es-es.cab

Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-Basic-es-es-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-Handwriting-es-es-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-OCR-es-es-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-Speech-es-es-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-TextToSpeech-es-es-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~es-ES~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~es-ES~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~es-ES~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~es-ES~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~es-ES~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~es-ES~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~es-ES~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~es-ES~.cab

$languageList = Get-WinUserLanguageList
$languageList.Add("es-es")
Set-WinUserLanguageList $LanguageList -force
write-host 'AIB Customization: Finished installing Spanish (Spain) language packs'

# Japanese
write-host 'AIB Customization: Installing Japanese (Japan) language packs'
Add-AppProvisionedPackage -Online -PackagePath $langDrive\LocalExperiencePack\ja-jp\LanguageExperiencePack.ja-JP.Neutral.appx -LicensePath $langDrive\LocalExperiencePack\ja-jp\License.xml

Add-WindowsPackage -Online -PackagePath $langPackPath\Microsoft-Windows-Client-Language-Pack_x64_ja-jp.cab

Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-Basic-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-Handwriting-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-OCR-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-Speech-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-LanguageFeatures-TextToSpeech-ja-jp-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~ja-JP~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~ja-JP~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~ja-JP~.cab
Add-WindowsPackage -Online -PackagePath $fodDrive\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~ja-JP~.cab

$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("ja-jp")
Set-WinUserLanguageList $LanguageList -force
write-host 'AIB Customization: Finished installing Japanese (Japan) language packs'

# Unmount ISOs
write-host 'AIB Customization: Unmounting ISOs'
Dismount-DiskImage -ImagePath $langOutputPath
Dismount-DiskImage -ImagePath $fodOutputPath
#Dismount-DiskImage -ImagePath $inboxAppsOutputPath
write-host 'AIB Customization: Finished unmounting ISOs'