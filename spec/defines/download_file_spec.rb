require 'spec_helper'

powershell = 'powershell.exe -ExecutionPolicy RemoteSigned'

describe 'download_file', :type => :define do
	describe 'when downloading a file without a proxy' do
        let(:title)  {'Download DotNet 4.0'}
		let(:params) { { :url => 'http://myserver.com/test.exe', :destination => 'c:\temp' } }
		
		it { should contain_exec('download-test.exe').with({
                                                         'command' => "c:\\temp\\download.ps1",
                                                         'onlyif'  => "if(Test-Path -Path 'c:\\temp\\test.exe') { exit 1 } else { exit 0 }",
                                                     })}
	end

	describe 'when downloading a file using a proxy server' do
        let(:title)  {'Download DotNet 4.0'}
		let(:params) { { :url => 'http://myserver.com/test.exe', :destination => 'c:\temp', :proxyAddress => 'test-proxy-01:8888' } }
		
		it { should contain_exec('download-test.exe').with({
                                                         'command' => "c:\\temp\\download.ps1",
                                                         'onlyif'  => "if(Test-Path -Path 'c:\\temp\\test.exe') { exit 1 } else { exit 0 }",
                                                     })}
	end

    describe 'when not passing a destination url to the download define' do
		let(:title)  {'Download DotNet 4.0'}
  		let(:params) { {:url => 'http://myserver.com/test.exe' } }
		
		it { expect { should contain_exec('download-test.exe')}.to raise_error(Puppet::Error, /Must pass destination to Download_file/)}
    end

    describe 'when not passing a URL to the file to download to the define' do
		let(:title)  {'Download DotNet 4.0'}
  		let(:params) { {:destination => 'c:\temp' } }
		
		it { expect { should contain_exec('download-test.exe')}.to raise_error(Puppet::Error, /Must pass url to Download_file/)}
    end
end
