require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  if host['platform'] =~ %r{windows}
    include Serverspec::Helper::Windows
    include Serverspec::Helper::WinRM
  end

  version = ENV.fetch('PUPPET_GEM_VERSION', nil)
  install_puppet(version: version)
end

Spec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    # The gets around a bug where windows can't validate the cert when using https
    forge_repo = '--module_repository=http://forge.puppetlabs.com'

    hosts.each do |host|
      c.host = host

      if host['platform'] =~ %r{windows}
        endpoint = 'http://127.0.0.1:5985/wsman'
        c.winrm = WinRM::WinRMWebService.new(endpoint, :ssl, user: 'vagrant', pass: 'vagrant', basic_auth_only: true)
        c.winrm.set_timeout 300
      end

      path = File.expand_path(File.dirname(__FILE__) + '/../').split('/')
      name = path[path.length - 1].split('-')[1]

      copy_module_to(host, source: proj_root, module_name: name)

      on host, puppet('module', 'install', forge_repo, 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]

      on host, puppet('module', 'install', forge_repo, 'puppetlabs-powershell'), acceptable_exit_codes: [0, 1]
    end
  end
end
