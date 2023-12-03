function Print-ExtensionInfo
{
   Param(
      [Parameter(Mandatory)][string] $browserName,
      [Parameter(Mandatory)][string] $profileDir,
      [Parameter(Mandatory)][hashtable] $profiles,
      [Parameter(Mandatory)][hashtable] $extensionInfo,
      [Parameter(Mandatory)][string] $user,
      [Parameter(Mandatory)][bool] $ExposeLoginInfo = $false
   )

   # Field names
   $osUserNameField                    = "OsUser"
   $browserNameField                   = "Browser"
   $profileDirField                    = "ProfileDir"
   $profileNameField                   = "ProfileName"
   $profileGaiaNameField               = "ProfileGaiaName"
   $profileUserNameField               = "ProfileUserName"
   $extensionIdField                   = "ExtensionId"
   $extensionNameField                 = "ExtensionName"
   $extensionVersionField              = "ExtensionVersion"
   $extensionFromWebstoreField         = "ExtensionFromWebstore"
   $extensionInstalledByDefaultField   = "ExtensionInstalledByDefault"
   $extensionStateField                = "ExtensionState"
   $extensionInstallTimeField          = "ExtensionInstallTime"

   # Field data
   $userName         = $user
   $profileName      = $profiles[$profileDir].profileName
   if ($ExposeLoginInfo)
   {
      $profileGaiaName  = $profiles[$profileDir].gaiaName
      $profileUserName  = $profiles[$profileDir].userName
   }
   else
   {
      $profileGaiaName  = ""
      $profileUserName  = ""
   }

   # Process each extension
   foreach ($extensionId in $extensionInfo.keys)
   {
      $extensionName                = $extensionInfo[$extensionId].name
      $extensionVersion             = $extensionInfo[$extensionId].version
      $extensionFromWebstore        = $extensionInfo[$extensionId].fromWebstore
      $extensionInstalledByDefault  = $extensionInfo[$extensionId].installedByDefault
      $extensionState               = $extensionInfo[$extensionId].state
      $extensionInstallTime         = $extensionInfo[$extensionId].installTime

      $output = [PSCustomObject]@{
                  $osUserNameField="$userName"; 
                  $browserNameField="$browserName"; 
                  $profileDirField="$profileDir"; 
                  $profileNameField="$profileName"; 
                  $profileGaiaNameField="$profileGaiaName"; 
                  $profileUserNameField="$profileUserName";
                  $extensionIdField="$extensionId";
                  $extensionNameField="$extensionName";
                  $extensionVersionField="$extensionVersion";
                  $extensionFromWebstoreField="$extensionFromWebstore";
                  $extensionStateField="$extensionState";
                  $extensionInstallTimeField="$extensionInstallTime";
                  $extensionInstalledByDefaultField="$extensionInstalledByDefault"}

      Write-Output $output
   }
}
