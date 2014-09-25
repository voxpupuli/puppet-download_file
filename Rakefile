require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.relative = true

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = ["**/spec/**/*.pp", "**/vendor/**/*.pp"]
  config.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
end

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*"
]

PuppetSyntax.exclude_paths = exclude_paths

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :spec
]
