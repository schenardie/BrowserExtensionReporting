function Get-FirefoxExtensionJsonFromPreferences {
   Param(
      [Parameter(Mandatory)][string] $preferencesFile
   )

   # Check if the secure preferences file exists
   if (-not (Test-Path $preferencesFile -PathType Leaf)) {
      return
   }

   # Read the preferences file & convert to JSON
   $preferencesJson = Get-Content -Path $preferencesFile -Encoding UTF8 | ConvertFrom-Json

   # The extensions are children of extensions > settings
   return $preferencesJson.addons
}