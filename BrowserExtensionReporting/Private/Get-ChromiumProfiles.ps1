function Get-ChromiumProfiles {
   Param(
      [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$userDataPath
   )

   # Out variable
   $profilesMap = @{}
   foreach ($userDataPath in $userDataPath) {
      # Build the path to the local state file
      $localStatePath = $userDataPath + "\Local State"

      # Check if the local state file exists
      if (-not (Test-Path $localStatePath -PathType Leaf)) {
         return $profilesMap
      }

      # Read the local state file & convert to JSON
      $localStateJson = Get-Content -Path $localStatePath -Encoding UTF8 | ConvertFrom-Json

      # The profiles are children of profile > info_cache
      $infoCacheJson = $localStateJson.profile.info_cache
      $profileDirs = $infoCacheJson.psobject.properties.name

      # Extract properties of each profile
      foreach ($profileDir in $profileDirs) {
         # Build a hashtable with the properties of this profile
         $profileMap =
         @{
            profileName = $infoCacheJson.$profileDir.name        # Name of the browser profile, e.g.: Person 1
            gaiaName    = $infoCacheJson.$profileDir.gaia_name   # Name of the profile's user, e.g.: John Doe
            userName    = $infoCacheJson.$profileDir.user_name   # Email of the profile's user, e.g.: john@domain.com
         }

         # Add this profile to the list of profiles
         $profilesMap[$profileDir] = $profileMap;
      }
   }

   # Return the list of profiles
   return $profilesMap
}