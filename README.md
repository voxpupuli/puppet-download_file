puppet-download_file
=====================

Small define that will allow you to download a file, on Windows, for usage during an installation. This was created so that we didn't have to store large binaries (DotNet4.0 etc.) in our modules.

[![Build Status](https://travis-ci.org/opentable/puppet-download_file.png?branch=master)](https://travis-ci.org/opentable/puppet-download_file)

Usage
--

    download_file { "Download dotnet 4.0" :
        url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
        destination_directory => 'c:\temp'
    }
    
    
This can now be used in other modules that need to install applications. All you would need to do is to have a require (as used with puppet-dotnet, by Liam Bennett) e.g.

    download_file { "Download dotnet 4.0" :
      url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
      destination_directory => 'c:\temp'
    }

    exec { 'install-dotnet-4':
      command   => "c:\\temp\\dotNetFx40_Full_x86_x64.exe /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::f_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }",
      require   => Download_file['Download dotnet 4.0']
    }
    
You can use this module and specify a proxy to download the file. It's usage would then be as follows:

    download_file { "Download dotnet 4.0" :
      url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
      destination_directory => 'c:\temp',
      proxyAddress          => 'http://myproxy.com:port',
    }

    exec { 'install-dotnet-4':
      command   => "c:\\temp\\dotNetFx40_Full_x86_x64.exe /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::f_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }",
      require   => Download_file['Download dotnet 4.0']
    }

The proxy will be used as part of the download using PowerShell. This does not set a system wide proxy
