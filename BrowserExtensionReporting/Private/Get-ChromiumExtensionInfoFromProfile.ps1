function Get-ChromiumExtensionInfoFromProfile {
   Param(
      [Parameter(Mandatory)][string] $profilePath
   )

   # Out variable
   $extensionsMap = @{}

   # Try to get extension info from secure preferences
   $extensionsJson = Get-ChromiumExtensionJsonFromPreferences ($profilePath + "\Secure Preferences")
   if ($null -eq $extensionsJson) {
      # Try regular preferences instead
      $extensionsJson = Get-ChromiumExtensionJsonFromPreferences ($profilePath + "\Preferences")
      if ($null -eq $extensionsJson) {
         return $extensionsMap
      }
   }

   # The extensions are children of extensions > settings
   $extensionIds = $extensionsJson.psobject.properties.name

   # Extract properties of each extension
   foreach ($extensionId in $extensionIds) {
      # Ignore extensions installed by default (that also don't show up in the extensions UI)
      # $installedByDefault = $extensionsJson.$extensionId.was_installed_by_default
      # if ($installedByDefault -eq $true)
      # {
      #    continue
      # }

      # Ignore extensions located outside the user data directory (e.g., extensions that ship with the browser)
      # Location values seen:
      #    1: Profile (user data)
      #    5: Install directory (program files)
      #   10: Profile (user data) [not sure about the difference to 1]
      $location = $extensionsJson.$extensionId.location
      if ($location -eq 5) {
         continue
      }

      # Ignore extensions whose directory does not exist
      $extensionPath = $profilePath + "\Extensions\" + $extensionId
      if (-not (Test-Path $extensionPath)) {
         continue
      }

      # Last install time
      $updateTimeMs = Convert-ChromeTimestampToEpochMs $extensionsJson.$extensionId.first_install_time

      # Manifest
      $manifestJson = $extensionsJson.$extensionId.manifest
      if ($null -eq $manifestJson) {
         # Ignore entries without a manifest
         continue
      }
      $name = $manifestJson.name
      $version = $manifestJson.version

      #Determine store
      if ($manifestJson.update_url -match "^https://clients2\.google\.com/service/update2/crx$") {
         $fromWebstore = "Chrome"
      } elseif ($manifestJson.update_url -match "^https://edge.microsoft.com/extensionwebstorebase/v1/crx") {
         $fromWebstore = "Edge"
      } else {
         $fromWebstore = "Other"
      }

      # Build a hashtable with the properties of this extension
      $extensionMap =
      @{
         name               = $name                                                  # Extension name
         version            = $version                                               # Extension version
         fromWebstore       = $fromWebstore                                            # Was the extension installed from the Chrome Web Store?
         installedByDefault = $extensionsJson.$extensionId.was_installed_by_default  # Was the extension installed by default?
         state              = $extensionsJson.$extensionId.state                     # Extension state (1 = enabled)
         installTime        = $updateTimeMs                                          # Timestamp of the last installation (= update) as Unix epoch in ms
      }

      # Add this extension to the list of extensions
      $extensionsMap[$extensionId] = $extensionMap;
   }

   # Return the list of extensions
   return $extensionsMap
}