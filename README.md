# Overview
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/BrowserExtensionReporting)

This module was created to provide reporting on browser extensions installed on endpoints.

Currently the following function is supported in the module:
- Get-BrowserExtensionInfo

## Installing the module from PSGallery
The BrowserExtensionInfo module is published to the PowerShell Gallery. Install it on your system by running the following in an PowerShell console:
```PowerShell
Install-Module -Name "BrowserExtensionReporting"
```

## Using the module

Since the module only has one public function (*Get-BrowserExtensionInfo*) the parameters are explained below:

**Broswer** is to select all the browsers you want to collect extensions information from. Leaving it black defaults to all supported ('Edge', 'EdgeDev', 'EdgeBeta', 'EdgeCanary', 'Chrome', 'ChromeDev', 'ChromeBeta', 'ChromeCanary', 'Firefox')

**User** is to select from which users you would like to collect the data. Any thing other than current will require the user executing the function to be member of local administrators (since you cannot read other users folder without it).

**ExposeLoginInfo** is a boolean ($true or $false) to define if you would like to see UserName and E-mail in case the profile is signed to a company or personal account. By default is set to $false so on bulk collection does not expose possible unwanted PII.

```PowerShell
# Get all Firefox extensions for the current logged on user (active on the console)
Get-BrowserExtensionInfo -browser Firefox -User LoggedOnUser -Verbose

# Get all Browsers extensions for all users and exposed the profiles logged in with UserName and E-mail (required to run with an account member of Administrators group)
Get-BrowserExtensionInfo -User AllUsers -ExposeLoginInfo $True

# Get all Chrome Dev and Edge Dev extensions for the current user running the script.
Get-BrowserExtensionInfo -Browser ChromeDev,EdgeDev -User CurrentUser
```
## Special thanks
Big thanks to [Helge Klein](https://twitter.com/HelgeKlein) for ceding many functions used on this module which are based on his script for [uberAgent](https://uberagent.com/docs/uberagent/latest/practice-guides/building-a-browser-extension-inventory-report-chrome-edge-firefox/)
