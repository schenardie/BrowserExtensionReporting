function Get-LocalAccounts {    
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $LocalAccounts = @()
        Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' | Where-Object { $_.Name -like "*S-1-5-21-*" } | ForEach-Object {
            $LocalAccount = $_.GetValue('ProfileImagePath')
            $LocalAccounts += $LocalAccount
        }
        return $LocalAccounts
    }
    else { write-host "To list local accounts you need to run this script as an administrator"; break }
}