function Get-FirefoxProfileUserInfo {
   Param(
      [Parameter(Mandatory)][string] $profileDir,
      [Parameter(Mandatory)][string] $profilePath
   )

   # Out variables
   $userEmail = ""
   $profilesMap = @{}

   # Extract the profile name from the profile directory (everything after the first dot)
   $profileName = ""
   if ($profileDir -match "[^\.]+\.(.+)") {
      $profileName = $Matches[1]
   }

   # Build the path to the file signedInUser.json
   $signedInUserPath = $profilePath + "\signedInUser.json"

   # Check if the signedInUser.json file exists
   if (Test-Path $signedInUserPath -PathType Leaf) {
      # Read the signedInUser.json file & convert to JSON
      $signedInUserJson = Get-Content -Path $signedInUserPath -Encoding UTF8 | ConvertFrom-Json

      # User Info is in accountData
      $accountData = $signedInUserJson.accountData
      if ($null -ne $accountData) {
         $userEmail = $accountData.email
      }
   }

   # Build a hashtable with the properties of this profile
   $profileMap =
   @{
      userName    = $userEmail         # Email of the profile's user, e.g.: john@domain.com
      profileName = $profileName       # Name of the browser profile, e.g.: Person 1
   }

   # Add this profile to the list of profiles
   $profilesMap[$profileDir] = $profileMap;

   # Return the list of profiles
   return $profilesMap
}
