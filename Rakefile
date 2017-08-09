require 'rubygems'
require 'spec/rake/spectask'
require 'rubocop/rake_task'

task :default => :spec

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--color', '--format specdoc']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Run rubocop'
task :rubocop do
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['--display-cop-names']
  end
end
