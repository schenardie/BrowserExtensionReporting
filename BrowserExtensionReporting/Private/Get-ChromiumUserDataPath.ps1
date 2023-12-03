function Get-ChromiumUserDataPath {
    Param(
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Browser,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$User
    )
    $ChromiumUserDataPath = $user | foreach-object {
        $u = $_
        # Build the path to the user data directory
        $usersDataPath = $browser | ForEach-Object {  
            switch ($_) {

                Edge {
                    Write-Verbose "Querying Edge profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Microsoft\Edge\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "Edge profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                EdgeDev {
                    Write-Verbose "Querying Edge Dev profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Microsoft\Edge Dev\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "Edge Dev profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                EdgeBeta {
                    Write-Verbose "Querying Edge Beta profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Microsoft\Edge Beta\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "Edge Beta profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                EdgeCanary {
                    Write-Verbose "Querying Edge Canary profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Microsoft\Edge SxS\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "Edge Canary profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                Chrome {
                    Write-Verbose "Querying Chrome profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Google\Chrome\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "Chrome profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                ChromeDev {
                    Write-Verbose "Querying Chrome Dev profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Google\Chrome Dev\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "ChromeDev profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                ChromeBeta {
                    Write-Verbose "Querying Chrome Beta profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Google\Chrome Beta\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "Chrome Beta profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                ChromeCanary {
                    Write-Verbose "Querying Chrome Canary profiles for user $u"
                    $userDataPath = $u + "\Appdata\Local\Google\Chrome SxS\User Data" 
                    # Check if the Chrome data directory exists
                    if (Test-Path $userDataPath) {
                        return  $userDataPath
                        Write-Verbose "Chrome Canary profile found $($userDataPath)"
                    }
                    else {
                        return
                    }
                }
                Default { Write-host "$Browser invalid" }
            }
        
        }
        return $usersDataPath
    }
    return $ChromiumUserDataPath
}