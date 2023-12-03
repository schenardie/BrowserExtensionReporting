function Get-FirefoxExtensionInfoFromProfile {
   Param(
      [Parameter(Mandatory)][string] $profilePath
   )

   # Out variable
   $extensionsMap = @{}

   # Try to get extension info from extensions.json
   $extensionsJson = Get-FirefoxExtensionJsonFromPreferences ($profilePath + "\extensions.json")
   if ($null -eq $extensionsJson) {
      return $extensionsMap
   }

   # Extract properties of each extension
   foreach ($extensionJson in $extensionsJson) {
      # Ignore addons outside the profile
      if ($extensionJson.location -ne "app-profile") {
         continue
      }
      # Ignore addons that are not extensions
      if ($extensionJson.type -ne "extension") {
         continue
      }

      # State (enabled/disabled)
      $state = "0"
      if ($extensionJson.active -eq $true) {
         $state = "1"
      }

      # Default locale
      $defaultLocale = $extensionJson.defaultLocale
      if ($null -eq $defaultLocale) {
         # Ignore entries without a manifest
         continue
      }
      $name = $defaultLocale.name

      # Installation source: Firefox Addons?
      # sourceURI must be https://addons.cdn.mozilla.net or https://addons.mozilla.org
      $fromFirefoxAddons = $false
      if ($extensionJson.sourceURI -match "^http(s)?://addons\.(cdn\.)?mozilla\.") {
         $fromFirefoxAddons = "Firefox"
      }
      else{
         $fromFirefoxAddons = "Other"}

      # Build a hashtable with the properties of this extension
      $extensionMap =
      @{
         name         = $name                       # Extension name
         version      = $extensionJson.version      # Extension version
         fromWebstore = $fromFirefoxAddons          # Was the extension installed from Firefox Addons?
         state        = $state                      # Extension state (1 = enabled)
         installTime  = $extensionJson.updateDate   # Last update timestamp as Unix epoch in ms
      }

      # Add this extension to the list of extensions
      $extensionsMap[$extensionJson.id] = $extensionMap;
   }

   # Return the list of extensions
   return $extensionsMap
}
