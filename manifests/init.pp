define download_file ($url, $destination, $proxyAddress=undef) {
  $filename = regsubst($url, '^http.*\/([0-9a-zA-Z_.-]+.exe)$', '\1')
  
  validate_re($url, '.+')
  validate_re($destination, '.+')
  validate_re($filename, '.+')

  file { "download-${filename}.ps1" :
    path    => "c:/temp/download.ps1",
    ensure  => present,
    content => template('download_file/download.ps1.erb'),
  }

  exec { "download-${filename}" :
    command   => "c:/temp/download.ps1",
    provider  => powershell,
    onlyif    => "if(Test-Path -Path '${destination}\\${filename}') { exit 1 } else { exit 0 }",
    logoutput => true,
    require   => File["download-${filename}.ps1"]
  }
}