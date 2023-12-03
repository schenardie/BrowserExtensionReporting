function Get-EntraAccounts {
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $EntraAccounts = @()              
        Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' | Where-Object { $_.Name -like "*S-1-12-*" } | ForEach-Object {
            $EntraAccount = $_.GetValue('ProfileImagePath')
            $EntraAccounts += $EntraAccount
        }
        return $EntraAccounts
    }
    else { write-host "To list entra accounts you need to run this script as an administrator"; break }
}