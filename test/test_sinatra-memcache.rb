require File.dirname(__FILE__) + '/fixture'
require 'test/unit'
require 'rack/test'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    @client = MemCache.new "localhost:11211", :namespace => "test"
  end

  def test_index
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
  end

  def test_cache
    get '/cache'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
    assert_equal 'Hello World', @client['cache', true]
  end

  def test_cache_custom
    get '/cache2'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
    assert_equal 'Hello World', @client['cache2']
    sleep(1)
    assert_nil @client['cache2']
  end

  def test_expire_key
    get '/cache'
    get '/expire'
    assert_nil @client['cache', true]
  end

  def test_expire_regexp
    get '/cache'
    get '/cache2'
    get '/expire_re'
    assert_nil @client['cache', true]
    assert_nil @client['cache2']
  end
end
