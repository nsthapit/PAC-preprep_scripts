$vers = (Get-WmiObject -class Win32_OperatingSystem).Caption

#if version is windows 11 disable autologin and logoff current user to prepare for lockdown script
if ($vers -like '*Windows 11*') {
    Write-Output "It is on Windows 11"
$profileuser = "user"
$profile_path = "c:\users\$profileuser\ntuser.dat"
$file_path= "c:\temp"
 
#download the lockdown zip file from Nextcloud
$Url = "https://cloud.mmxgroup.ca/s/HjZHT9iBgckNX9B/download/win11_lock.zip"
$DownloadFile= $file_path + $(Split-Path -Path $Url -Leaf)
Invoke-WebRequest -Uri $Url -OutFile $DownloadFile

$Url1 = "https://github.com/valinet/ExplorerPatcher/releases/latest/download/ep_setup.exe"
$DownloadFile1 = "C:\temp\ep_setup.exe"
Invoke-WebRequest -Uri $Url1 -OutFile $DownloadFile1

#extract contents of the zip file to win11pac folder
Expand-Archive $DownloadFile $file_path\win11pac\ -Force

#install explorer patcher
Start-Process $file_path\ep_setup.exe "/S"

#load the registry for the user profile 
reg load HKU\$profileuser $profile_path | Out-Null

#apply the registry keys 
Invoke-Command {reg import $file_path\win11pac\GPO_policies.reg 2>&1 | Out-Null}

#unload the profile
reg unload HKU\$profileuser

Write-Output "Completed Applying Registry edits"

    $RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    $Name         = 'AutoAdminLogon'
    $Value        = '1'

    $Name1         = 'ForceAutoLogon'
    $Value1        = '1'

    $Name2         = 'DefaultUserName'
    $Value2        = 'User'

    $Name3         = 'DefaultPassword'
    $Value3        = 'Zyd307'
Write-Output "Windows 11 machine. Regsitry keys modified and restarting."
Write-Host "Windows 11 machine. Regsitry keys modified and restarting."

If (-NOT (Test-Path $RegistryPath)) {
New-Item -Path $RegistryPath -Force | Out-Null
}
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force
New-ItemProperty -Path $RegistryPath -Name $Name1 -Value $Value1 -PropertyType DWORD -Force
New-ItemProperty -Path $RegistryPath -Name $Name2 -Value $Value2 -PropertyType String -Force
New-ItemProperty -Path $RegistryPath -Name $Name3 -Value $Value3 -PropertyType String -Force

#Stop-Computer -Logoff
Restart-Computer -Force
}
else {

    Write-Host "Still on Windows 10. No actions Performed."
    Write-Output "Still on Windows 10. No actions Performed."
}

