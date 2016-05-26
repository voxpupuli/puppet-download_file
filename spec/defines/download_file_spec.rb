require 'spec_helper'

describe 'download_file', type: :define do
  describe 'when downloading a file without a proxy' do
    let(:title)  { 'Download DotNet 4.0' }
    let(:params) do {
      url: 'http://myserver.com/test.exe',
      destination_directory: 'c:\temp'
    }
    end

    it do should contain_exec('download-test.exe').with(
      'command' => 'c:\\temp\\download-test.ps1',
      'onlyif'  => "if(Test-Path -Path 'c:\\temp\\test.exe') { exit 1 } else { exit 0 }",
    )
    end
  end

  describe 'when downloading a file with a empty string proxy' do
    let(:title)  { 'Download DotNet 4.0' }
    let(:params) do {
      url: 'http://myserver.com/test.exe',
      destination_directory: 'c:\temp',
      proxy_address: ''
    }
    end

    it do should contain_exec('download-test.exe').with(
      'command' => 'c:\\temp\\download-test.ps1',
      'onlyif'  => "if(Test-Path -Path 'c:\\temp\\test.exe') { exit 1 } else { exit 0 }",
    )
    end
  end

  describe 'when downloading a file without a proxy we want to check that the erb gets evaluated correctly' do
    let(:title)  { 'Download DotNet 4.0' }
    let(:params) { { url: 'http://myserver.com/test.exe', destination_directory: 'c:\temp' } }

    ps1 = <<-PS1.gsub(/^ {6}/, '')
      $webclient = New-Object System.Net.WebClient
      $proxyAddress = ''
      if ($proxyAddress -ne '') {
        if (!$proxyAddress.StartsWith('http://')) {
          $proxyAddress = 'http://' + $proxyAddress
        }

        $proxy = new-object System.Net.WebProxy
        $proxy.Address = $proxyAddress
        $webclient.proxy = $proxy
      }

      try {
        $webclient.DownloadFile('http://myserver.com/test.exe', 'c:\\temp\\test.exe')
      }
      catch [Exception] {
        write-host $_.Exception.GetType().FullName
        write-host $_.Exception.Message
        write-host $_.Exception.InnerException.Message
        throw $_.Exception
      }
    PS1

    it { should contain_file('download-test.exe.ps1').with_content(ps1) }
  end

  describe 'when downloading a file using a proxy server' do
    let(:title)  { 'Download DotNet 4.0' }
    let(:params) do {
      url: 'http://myserver.com/test.exe',
      destination_directory: 'c:\temp',
      proxy_address: 'test-proxy-01:8888'
    }
    end

    it do should contain_exec('download-test.exe').with(
      'command' => 'c:\\temp\\download-test.ps1',
      'onlyif'  => "if(Test-Path -Path 'c:\\temp\\test.exe') { exit 1 } else { exit 0 }",
    )
    end
  end

  describe 'when downloading a file using a proxy server we want to check that the erb gets evaluated correctly' do
    let(:title)  { 'Download DotNet 4.0' }
    let(:params) do {
      url: 'http://myserver.com/test.exe',
      destination_directory: 'c:\temp',
      proxy_address: 'test-proxy-01:8888'
    }
    end

    ps1 = <<-PS1.gsub(/^ {6}/, '')
      $webclient = New-Object System.Net.WebClient
      $proxyAddress = 'test-proxy-01:8888'
      if ($proxyAddress -ne '') {
        if (!$proxyAddress.StartsWith('http://')) {
          $proxyAddress = 'http://' + $proxyAddress
        }

        $proxy = new-object System.Net.WebProxy
        $proxy.Address = $proxyAddress
        $webclient.proxy = $proxy
      }

      try {
        $webclient.DownloadFile('http://myserver.com/test.exe', 'c:\\temp\\test.exe')
      }
      catch [Exception] {
        write-host $_.Exception.GetType().FullName
        write-host $_.Exception.Message
        write-host $_.Exception.InnerException.Message
        throw $_.Exception
      }
    PS1

    it { should contain_file('download-test.exe.ps1').with_content(ps1) }
  end

  describe 'when not passing a destination url to the download define' do
    let(:title)  { 'Download DotNet 4.0' }
    let(:params) do {
      url: 'http://myserver.com/test.exe'
    }
    end

    it do
      expect do
        should contain_exec('download-test.exe')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'when not passing a URL to the file to download to the define' do
    let(:title)  { 'Download DotNet 4.0' }
    let(:params) do {
      destination_directory: 'c:\temp'
    }
    end

    it do
      expect do
        should contain_exec('download-test.exe')
      end.to raise_error(Puppet::Error)
    end
  end

  describe 'when downloading a non-exe file' do
    let(:title)  { 'Download MSI' }
    let(:params) do {
      url: 'http://myserver.com/test.msi',
      destination_directory: 'c:\temp'
    }
    end

    it do should contain_exec('download-test.msi').with(
      'command' => 'c:\\temp\\download-test.ps1',
      'onlyif'  => "if(Test-Path -Path 'c:\\temp\\test.msi') { exit 1 } else { exit 0 }",
    )
    end
  end

  describe 'when downloading the nodejs installer' do
    let(:title)  { 'Download nodejs installer' }
    let(:params) do {
      url: 'http://artifactory.otsql.opentable.com:8081/artifactory/simple/puppet/windows/nodejs/0.10.15/nodejs-0.10.15-x64.msi',
      destination_directory: 'c:\temp'
    }
    end

    it do should contain_exec('download-nodejs-0.10.15-x64.msi').with(
      'command' => 'c:\\temp\\download-nodejs-0.10.15-x64.ps1',
      'onlyif'  => "if(Test-Path -Path 'c:\\temp\\nodejs-0.10.15-x64.msi') { exit 1 } else { exit 0 }",
    )
    end
  end

  describe 'when the destination is a folder' do
    let(:title)  { 'Download nodejs installer' }
    let(:params) do
      {
        url: 'http://my.server/test.exe',
        destination_directory: 'c:\temp'
      }
    end

    it do should contain_exec('download-test.exe').with(
      'command' => 'c:\\temp\\download-test.ps1',
      'onlyif'  => "if(Test-Path -Path 'c:\\temp\\test.exe') { exit 1 } else { exit 0 }",
    )
    end
  end

  describe 'when the filename is different to the filename in the url' do
    let(:title)  { 'Download nodejs installer' }
    let :params do
      {
        url: 'http://my.server/test.exe',
        destination_directory: 'c:\temp',
        destination_file: 'foo.exe'
      }
    end

    it do should contain_exec('download-foo.exe').with(
      'command' => 'c:\\temp\\download-test.ps1',
      'onlyif'  => "if(Test-Path -Path 'c:\\temp\\foo.exe') { exit 1 } else { exit 0 }",
    )
    end
  end

  describe 'the timeout parameter' do
    context 'when not specified' do
      let(:title)  { 'Download nodejs installer' }
      let(:params) do {
        url: 'http://my.server/test.exe',
        destination_directory: 'c:\temp',
        destination_file: 'foo.exe'
      }
      end
      it { should contain_exec('download-foo.exe').with('timeout' => nil) }
    end

    context 'when given an integer value' do
      let(:title)  { 'Download nodejs installer' }
      let(:params) do {
        url: 'http://my.server/test.exe',
        destination_directory: 'c:\temp',
        destination_file: 'foo.exe',
        timeout: '30000'
      }
      end
      it { should contain_exec('download-foo.exe').with('timeout' => '30000') }
    end

    context 'when given a non-integer value' do
      let(:title)  { 'Download nodejs installer' }
      let(:params) do {
        url: 'http://my.server/test.exe',
        destination_directory: 'c:\temp',
        destination_file: 'foo.exe',
        timeout: 'this-cannot-work'
      }
      end
      it do
        expect do
          should contain_exec('download-foo.exe')
        end.to raise_error(Puppet::Error, /Integer/)
      end
    end
  end
end
