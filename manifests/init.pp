# Author::    Paul Stack  (mailto:pstack@opentable.com)
# Copyright:: Copyright (c) 2013 OpenTable Inc
# License::   MIT

# == Define Resource Type: download_file
#
# The download_file module allows you to download files on Windows
#
# === Requirements/Dependencies
#
# Currently requires the modules puppetlabs/stdlib and puppetlabs/powershell on
# the Puppet Forge in order to validate much of the the provided configuration.
#
# === Parameters
#
# [*url*]
# The http(s) destination of the file that you are looking to download
#
# [*destination_directory*]
# The full path to the directory on the system where the file will be downloaded to
#
# [*destination_file*]
# The optional name of the file to download onto the system.
#
# [*proxy_address*]
# The optional http proxy address to use when downloading the file
#
# [*timeout*]
# The optional timeout(in seconds) in case you expect to download big and slow file
#
# === Examples
#
# To download dotnet 4.0
#
#    download_file { "Download dotnet 4.0" :
#      url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
#      destination_directory => 'c:\temp'
#    }
#
# To download dotnet 4.0 using a proxy and extend operation timeout to 30000 seconds 
#
#    download_file { "Download dotnet 4.0" :
#      url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
#      destination_directory => 'c:\temp',
#      proxy_address         => 'http://corporateproxy.net:8080',
#      timeout               => 30000
#    }
#
define download_file(
  $url,
  $destination_directory,
  $destination_file = '',
  $proxyAddress=undef,
  $proxy_address=undef,
  $timeout = undef
) {

  if "x${destination_file}x" == 'xx' {
    $filename = regsubst($url, '^http.*\/([^\/]+)$', '\1')
  } else {
    $filename = $destination_file
  }

  if $timeout {
    validate_integer($timeout)
    Exec { timeout => $timeout }
  }

  $powershell_filename = regsubst($url, '^(.*\/)(.+?)(?:\.[^\.]*$|$)$', '\2')


  if $proxyAddress {
    warning("${module_name}: The use of proxyAddress in Download_file[${title}] is deprecated. Use proxy_address instead.")
    $proxy_address_real = $proxyAddress
  } else {
    $proxy_address_real = $proxy_address
  }

  if $proxyAddress and $proxy_address {
    fail ("${module_name}: Download_file[${title}] specifies both proxyAddress and proxy_address. Use proxy_address only.")
  }

  validate_re($url, '.+')
  validate_re($destination_directory, '.+')
  validate_re($filename, '.+')

  file { "download-${filename}.ps1":
    ensure  => present,
    path    => "${destination_directory}\\download-${powershell_filename}.ps1",
    content => template('download_file/download.ps1.erb'),
  }

  exec { "download-${filename}":
    command   => "${destination_directory}\\download-${powershell_filename}.ps1",
    provider  => powershell,
    onlyif    => "if(Test-Path -Path '${destination_directory}\\${filename}') { exit 1 } else { exit 0 }",
    logoutput => true,
    require   => File["download-${filename}.ps1"]
  }
}
