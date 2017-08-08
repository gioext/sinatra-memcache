require 'rubygems'
require 'rubocop/rake_task'

desc 'Run rubocop'
task :rubocop do
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = ['--display-cop-names']
  end
end
