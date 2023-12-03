function Get-AllAccounts {
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $EntraAccounts = Get-EntraAccounts
        $LocalAccounts = Get-LocalAccounts
        $VirtualAccounts = Get-VirtualAccounts
        return @($EntraAccounts) + @($LocalAccounts) + @($VirtualAccounts)
    }
    else { write-host "To list all accounts you need to run this script as an administrator"; break }
}


    