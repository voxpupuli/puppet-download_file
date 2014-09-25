require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet_blacksmith/rake_tasks'

if ENV['PUPPET_GEM_VERSION'] =~ /3.4/ && ENV['RUBY_VERSION'] !~ /1.8/
  require 'puppet-doc-lint/rake_task'
end

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.relative = true

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["**/spec/**/*.pp", "**/vendor/**/*.pp"]
  config.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
end

PuppetSyntax.exclude_paths = ["**/spec/**/*", "**/vendor/**/*]

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :spec
]
