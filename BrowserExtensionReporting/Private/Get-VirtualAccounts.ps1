function Get-VirtualAccounts {

    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $VirtualAccounts = @()
        Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' | Where-Object { $_.Name -like "*S-1-5-110-*" } | ForEach-Object {
            $VirtualAccount = $_.GetValue('ProfileImagePath')
            $VirtualAccounts += $VirtualAccount
        }
        return $VirtualAccounts
    }
    else { write-host "To list virtual accounts you need to run this script as an administrator"; break }
}