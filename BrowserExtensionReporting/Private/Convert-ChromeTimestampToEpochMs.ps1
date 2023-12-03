function Convert-ChromeTimestampToEpochMs {
   Param(
      [Parameter()][long] $chromeTimestamp
   )

   if ($chromeTimestamp -eq $null) {
      return
   }

   $filetime = $chromeTimestamp * 10
   $datetime = [datetime]::FromFileTime($filetime)
   return ([DateTimeOffset]$datetime).ToUnixTimeMilliseconds()
}