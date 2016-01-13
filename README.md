# puppet-download_file

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with download_file](#setup)
    * [What download_file affects](#what-download_file-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with download_file](#beginning-with-download_file)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview
The download_file module allows you to download files on Windows

[![Build Status](https://travis-ci.org/opentable/puppet-download_file.png?branch=master)](https://travis-ci.org/opentable/puppet-download_file)

##Module Description

The download_file module introduced a small define `download_file` that will allow you to download a file over http(s) for usage during an installation.
This was created because the package resource does not support http as a source for packages.
It is only supported on Windows.

##Setup
###What download_file affects
* Downloads files onto each node

###Setup Requirements
* download_file makes use of Powershell so you will need to have at least version 2.0 installed in order to use this module.

##Beginning

To download dotnet 4.0

```puppet
    download_file { "Download dotnet 4.0" :
      url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
      destination_directory => 'c:\temp'
    }
```

To download dotnet 4.0 using a proxy

```puppet
    download_file { "Download dotnet 4.0" :
      url                   => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
      destination_directory => 'c:\temp',
      proxy_address         => 'http://corporateproxy.net:8080'
    }
```

The proxy will be used as part of the download using PowerShell. This does not set a system wide proxy

##Usage

###Classes and Defined Types

####Defined Type: `download_file`

**Parameters within `download_file`:**
#####`url`
The http(s) destination of the file that you are looking to download

#####`destination_directory`
The full path to the directory on the system where the file will be downloaded to

#####`destination_file`
The optional name of the file to download onto the system.

#####`proxy_address`
The optional http proxy address to use when downloading the file

##Reference

###Defined Types
####Public Types
* [`download_file`](#defined-download_file): Download a give file

##Limitations

This module is tested on the following platforms:

* Windows 2008
* Windows 2008 R2
* Windows 2012
* Windows 2012 R2

It is tested with the OSS version of Puppet only.

###Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for full details on contributing to this project.
