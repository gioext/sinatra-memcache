# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra_memcache/version'

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'sinatra_memcache'
  s.version = Memcache::VERSION
  s.date = '2009-06-24'
  s.authors = %w[gioext dgvigil]
  s.email = 'dgvigil@gmail.com'
  s.homepage = 'https://github.com/dgvigil/sinatra-memcache'
  s.summary = 'Cache extension on Sinatra'

  s.files = [
    'Rakefile',
    'README.textile',
    'lib/sinatra/memcache.rb',
    'spec/sinatra-memcache_spec.rb',
    'spec/fixture.rb'
  ]

  s.require_paths = ['lib']
  s.add_dependency 'sinatra'
  s.add_dependency 'memcache-client'

  s.has_rdoc = 'false'
end
