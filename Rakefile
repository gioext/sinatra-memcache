require 'rubygems'
require 'spec/rake/spectask'

task default: :spec

desc 'Run all specs in spec directory'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--color', '--format specdoc']
  t.spec_files = FileList['spec/**/*_spec.rb']
end
