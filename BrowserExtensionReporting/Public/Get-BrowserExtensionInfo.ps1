function Get-BrowserExtensionInfo {
   <#
   .SYNOPSIS
      Get extension info from Chromium-based browsers and Firefox
   .DESCRIPTION   
      Get extension info from Chromium-based browsers and Firefox
   .PARAMETER verbose
      Enable extended output logging
   .PARAMETER Browser
      The browser(s) to get extension info from. Default: Edge, EdgeDev, EdgeBeta, EdgeCanary, Chrome, ChromeDev, ChromeBeta, ChromeCanary, Firefox
   .PARAMETER User
      The user(s) to get extension info from. Default: CurrentUser
      Options: CurrentUser = The user which the script is running as
               LoggedOnUser = The user logged on to the console (useful when running the script with System Account)
               AllUsers = All user accounts in the computer
               LocalUsers = All local user accounts in the computer
               VirtualUsers = All virtual user accounts in the computer
               EntraUsers = All entra users accounts in the computer
               Other = Provide any of those given the user executing the script has access to
   .PARAMETER ExposeLoginInfo
      Expose login info (gaia name, user name) in the output. That might contain sensitive information like personal username and e-mail address. Default: False
   .EXAMPLE
      Get-BrowserExtensionInfo -Browser Edge -User CurrentUser
      Get extension info from Edge for the current user executing the script
   .EXAMPLE
      Get-BrowserExtensionInfo -Browser Chrome -User AllUsers
      Get extension info from Chrome for all users
   .EXAMPLE
      Get-BrowserExtensionInfo -Browser Edge, Chrome -User Other
      Get extension info from Edge and Chrome for the account provided by the prompt.
   #>
   [cmdletbinding()]
   Param(
      [ValidateSet('Edge', 'EdgeDev', 'EdgeBeta', 'EdgeCanary', 'Chrome', 'ChromeDev', 'ChromeBeta', 'ChromeCanary', 'Firefox')]$Browser = $('Edge', 'EdgeDev', 'EdgeBeta', 'EdgeCanary', 'Chrome', 'ChromeDev', 'ChromeBeta', 'ChromeCanary', 'Firefox'),
      [ValidateSet("AllUsers", "LocalUsers", "VirtualUsers", "CurrentUser", "LoggedOnUser", "EntraUsers", "Other")][string]$User = "CurrentUser",
      [bool] $ExposeLoginInfo = $False
      )
   switch ($user) {
      AllUsers { $UserList = Get-AllAccounts }
      LocalUsers { $UserList = Get-LocalAccounts }
      VirtualUsers { $UserList = Get-VirtualAccounts }
      EntraUsers { $UserList = Get-EntraAccounts }
      CurrentUser { $UserList = $env:USERPROFILE }
      LoggedOnUser { $userlist = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' | Where-Object { ((Get-ItemProperty $_.PSPath).ProfileImagePath -split '\\' | Select-Object -Last 1) -eq "$(query user | Select-String '^>(\w+)' | ForEach-Object { $_.Matches[0].Groups[1].Value})" } | ForEach-Object { $_.GetValue('ProfileImagePath') } }
      Other {
         $other = Read-Host "Please provide user name"
         $userlist = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' | Where-Object { ((Get-ItemProperty $_.PSPath).ProfileImagePath -split '\\' | Select-Object -Last 1) -eq $other } | ForEach-Object { $_.GetValue('ProfileImagePath') }
         if ($null -eq $userlist) {
            Write-Error "User $other not found"
            return
         }
      }
      Default { Write-host "$User invalid" }
   }
   if ($UserList) {
      foreach ($browser in $Browser) {
         write-verbose "Processing $browser"
         if ($browser -Like "Chrome*" -or $browser -like "Edge*") {
            # Chromium-based browsers
            # Get the user data directory. If it doesn't exist, we cannot proceed.
            $userDataPath = Get-ChromiumUserDataPath $browser -user $UserList
            if ($null -eq $userDataPath) {
               Write-Verbose "No user directory found for browser $browser"
               continue
            }
            foreach ($userDataPath in $userDataPath) {
               # Get user info about the profiles
               $profiles = Get-ChromiumProfiles $userDataPath
               # Iterate over the profiles to get info on the extensions
               foreach ($profileDir in $profiles.keys) {
                  $usr = $userDataPath -replace "^.*\\Users\\(.*)\\Appdata.*$", '$1'
                  $profilePath = $userDataPath + "\" + $profileDir
                  # Check if the user profile directory exists
                  if (-not (Test-Path $profilePath)) {
                     continue
                  }
                  # Get extension info...
                  $extensionInfo = Get-ChromiumExtensionInfoFromProfile $profilePath
                  # ...and write it to stdout
                  Print-ExtensionInfo "$browser" $profileDir $profiles $extensionInfo $usr $ExposeLoginInfo
               }
            }
         }
         elseif ($browser -eq "Firefox") {
            # Firefox
            $profilesPath = Get-FirefoxProfilesPath -User $UserList
            if ($null -eq $profilesPath) {
               Write-Verbose "No user directory found for browser $browser"
               continue
            }
            foreach ($profilesPath in $profilesPath) {
               # Process each profile
               foreach ($profileDirObject in Get-ChildItem -Path $profilesPath -Directory) {
                  $usr = $profilesPath -replace "^.*\\Users\\(.*)\\Appdata.*$", '$1'
                  # Get user info
                  $profiles = Get-FirefoxProfileUserInfo $profileDirObject.Name $profileDirObject.FullName
                  # Get extension info...
                  $extensionInfo = Get-FirefoxExtensionInfoFromProfile $profileDirObject.FullName
                  # ...and write it to stdout
                  Print-ExtensionInfo "$browser" $profileDirObject.Name $profiles $extensionInfo $usr $ExposeLoginInfo
               }
            }
         }
         else {
            Write-Error "Invalid browser: $browser"
            return
         }
      }
   }
}