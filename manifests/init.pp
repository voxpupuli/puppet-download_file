define download_file ($url, $destination_directory, $proxyAddress='') {
  $filename = regsubst($url, '^http.*\/([^\/]+)$', '\1')
  $powershell_filename = regsubst($url, '^(.*\/)(.+?)(?:\.[^\.]*$|$)$', '\2')

  validate_re($url, '.+')
  validate_re($destination_directory, '.+')
  validate_re($filename, '.+')

  file { "download-${filename}.ps1" :
    ensure  => present,
    path    => "c:\\temp\\download-${powershell_filename}.ps1",
    content => template('download_file/download.ps1.erb'),
  }

  exec { "download-${filename}" :
    command   => "c:\\temp\\download-${powershell_filename}.ps1",
    provider  => powershell,
    onlyif    => "if(Test-Path -Path '${destination_directory}\\${filename}') { exit 1 } else { exit 0 }",
    logoutput => true,
    require   => File["download-${filename}.ps1"],
  }
}
