require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*"
]

PuppetSyntax.exclude_paths = exclude_paths

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :spec
]
