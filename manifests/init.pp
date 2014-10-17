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
# [*proxyAddress*]
# The optional http proxy address to use when downloading the file
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
# To download dotnet 4.0 using a proxy
#
#    download_file { "Download dotnet 4.0" :
#      url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
#      destination_directory => 'c:\temp',
#      proxyAddress          => 'http://corporateproxy.net:8080'
#    }
#
define download_file(
  $url,
  $destination_directory,
  $destination_file = '',
  $proxyAddress=''
) {

  if "x${destination_file}x" == 'xx' {
    $filename = regsubst($url, '^http.*\/([^\/]+)$', '\1')
  } else {
    $filename = $destination_file
  }

  $powershell_filename = regsubst($url, '^(.*\/)(.+?)(?:\.[^\.]*$|$)$', '\2')

  validate_re($url, '.+')
  validate_re($destination_directory, '.+')
  validate_re($filename, '.+')

  if defined(File['C:\temp']) {
    $tmp_dir = 'C:\temp'
  } elsif defined(File['C:/temp']) {
    $tmp_dir = 'C:/temp'
  } else {
    $tmp_dir = 'C:\temp'

    file { $tmp_dir:
      ensure => directory
    }
  }

  file { "download-${filename}.ps1":
    ensure  => present,
    path    => "${destination_directory}\\download-${powershell_filename}.ps1",
    content => template('download_file/download.ps1.erb'),
    require => File[$tmp_dir]
  }

  exec { "download-${filename}":
    command   => "${destination_directory}\\download-${powershell_filename}.ps1",
    provider  => powershell,
    onlyif    => "if(Test-Path -Path '${destination_directory}\\${filename}') { exit 1 } else { exit 0 }",
    logoutput => true,
    require   => File["download-${filename}.ps1"]
  }
}
