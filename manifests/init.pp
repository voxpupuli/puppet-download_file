define download_file ($url, $destination) {
  $filename = regsubst($url, '^http.*\/([0-9a-zA-Z_]+.exe)$', '\1')

  exec { "download-${filename}":
    command   => "powershell.exe -ExecutionPolicy ByPass -Command \"\$webclient = New-Object System.Net.WebClient;\$webclient.DownloadFile('${url}', '${destination}\\${filename}');\"",
    path      => "C:\\windows\\sysnative\\WindowsPowerShell\\v1.0;C:\\windows\\sysnative;${::path}",
    onlyif    => "powershell.exe -ExecutionPolicy ByPass -Command \"if(Test-Path -Path '${destination}\\${filename}') { exit 1 } else { exit 0 }\"",
    logoutput => true,
  }
}
