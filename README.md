[![Build Status](https://travis-ci.org/dgvigil/sinatra-memcache.svg?branch=master)](https://travis-ci.org/dgvigil/sinatra-memcache)

# Sinatra-MemCache

## Dependencies

memcache-client
zlib

## Install

```bash
sudo gem install gioext-sinatra-memcache
```

## Example

```ruby
require 'rubygems'
require 'sinatra'
require 'sinatra/memcache'

# cache
get '/cache1' do
  cache 'cache1' do
    sleep(5)
    'Hello Cache1'
  end
end

# args
get '/cache2' do
  cache 'cache2', :expiry => 10, :compress => true do
    sleep(3)
    'Hello Cache2'
  end
end

# cache object
get '/obj' do
  hash = cache 'obj' do
    sleep(2)
    { :a => 'Hello Object' }
  end
  hash[:a]
end

# expire
get '/expire' do
  expire 'cache1'
  expire /^cache/
  expire //
  'Hello Expire'
end

# default options
set :cache_server, "localhost:11211"
set :cache_namespace, "sinatra-memcache"
set :cache_enable, true
set :cache_logging, true
set :cache_default_expiry, 3600
set :cache_default_compress, false
```

## License

Copyright (c) 2009 Kazuki UCHIDA

Licensed under the MIT License:

- http://www.opensource.org/licenses/mit-license.php

