function Get-FirefoxProfilesPath {
    Param(
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$User
    )
    $FirefoxProfiles = @()
    foreach ($u in $user) {
        Write-Verbose "Querying Firefox profiles for user $u"
        $profilesPath = $u + "\Appdata\Roaming\Mozilla\Firefox\Profiles"
        if (Test-Path $profilesPath) {
            $FirefoxProfiles += $profilesPath
            Write-Verbose "Firefox profile found $($profilesPath)"
        }      
    }
    return $FirefoxProfiles
}