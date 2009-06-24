Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "sinatra-memcache"
  s.version = "0.1.0"
  s.date = "2009-06-24"
  s.authors = ["gioext"]
  s.email = "gioext@gmail.com"
  s.homepage = "http://github.com/gioext/sinatra-memcache"
  s.summary = "Cache extension on Sinatra"

  s.files = [
    "Rakefile",
    "README.textile",
    "lib/sinatra/memcache.rb",
    "test/sinatra-memcache_spec.rb",
    "test/fixture.rb"
  ]

  s.require_paths = ["lib"]
  s.add_dependency "sinatra"
  s.add_dependency "memcache-client"

  s.has_rdoc = "false"
end
