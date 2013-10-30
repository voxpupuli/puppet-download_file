define download_file ($url, $destination, $proxyAddress=undef) {
  $filename = regsubst($url, '^http.*\/([0-9a-zA-Z_.-]+.exe)$', '\1')
  
  $psCommand = "\$webclient = New-Object System.Net.WebClient;\$proxyAddress = '${proxyAddress}';if (\$proxyAddress -ne '') {if (!\$proxyAddress.StartsWith('http://')) { \$proxyAddress = 'http://' + \$proxyAddress }\$proxy = new-object System.Net.WebProxy;\$proxy.Address = \$proxyAddress;\$webclient.proxy = \$proxy;}try {\$webclient.DownloadFile('${url}', '${destination}\\${filename}')} catch [Exception] {write-host \$_.Exception.GetType().FullName; write-host \$_.Exception.Message; write-host \$_.Exception.InnerException.Message; throw \$_.Exception;}"
  validate_re($url, '.+')
  validate_re($destination, '.+')
  validate_re($filename, '.+')

  exec { "download-${filename}":
    command   => "powershell.exe -ExecutionPolicy ByPass -Command \"${psCommand}\"",
    path      => "C:\\windows\\sysnative\\WindowsPowerShell\\v1.0;C:\\windows\\sysnative;${::path}",
    onlyif    => "powershell.exe -ExecutionPolicy ByPass -Command \"if(Test-Path -Path '${destination}\\${filename}') { exit 1 } else { exit 0 }\"",
    logoutput => true,
  }
}
