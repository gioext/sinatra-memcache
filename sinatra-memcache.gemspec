# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "sinatra-memcache"
  s.version = '0.1.1'
  s.date = '2009-06-24'
  s.authors = %w[gioext dgvigil]
  s.email = 'dgvigil@gmail.com'
  s.homepage = 'https://github.com/dgvigil/sinatra-memcache'
  s.summary = 'Cache extension on Sinatra'
  s.require_paths = ['lib']
  s.add_dependency 'sinatra'
  s.add_dependency 'memcache-client'
  s.has_rdoc = 'false'
  s.license = 'MIT'
end
