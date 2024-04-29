
$usernameToSearch = "PAC User"
$profileDirectory = "C:\Users\user"
$ntuserPath = "$profileDirectory\ntuser.dat"
# Retrieve the specific local user account
$localUser = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True' AND Name='$usernameToSearch'"


if ($localUser) {
    # Display the SID of the user
    $userSID = $localUser.SID
    #Write-Host $localUser
    # Define the registry key path
    reg load "HKU\$userSID" $ntuserPath | Out-Null

    #$registryPath = "Registry::HKEY_USERS\$userSID\Software\Citrix\PNAgent"

New-PSDrive HKU Registry HKEY_USERS | out-null
        $user = get-wmiobject -Class Win32_Computersystem | select Username;
        #$sid = (New-Object System.Security.Principal.NTAccount($user.UserName)).Translate([System.Security.Principal.SecurityIdentifier]).value;
        New-Item -Path HKU:\$userSID\Software\Policies\Microsoft\Windows -Name WindowsCopilot -Force
        $key = "HKU:\$userSID\Software\Policies\Microsoft\Windows\WindowsCopilot"
        $val = (Get-Item "HKU:\$userSID\Software\Policies\Microsoft\Windows\WindowsCopilot") | out-null
        $reg = Get-Itemproperty -Path $key -Name TurnOffWindowsCopilot -erroraction 'silentlycontinue'
        if(-not($reg))
        	{
        		Write-Host "Registry key didn't exist, creating it now"
                        New-Itemproperty -path $Key -name "TurnOffWindowsCopilot" -value "1"  -PropertyType "dword" | out-null
        		exit 1
        	} 
        else
        	{
         		Write-Host "Registry key changed to 1"
        		Set-ItemProperty  -path $key -name "TurnOffWindowsCopilot" -value "1" | out-null
        		Exit 0  
            	}
}