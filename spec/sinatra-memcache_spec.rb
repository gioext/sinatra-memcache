# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require File.dirname(__FILE__) + '/fixture'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure { |c| c.include RSpecMixin }

describe 'Sinatra-MemCache basics' do
  before do
    @client = MemCache.new 'localhost:11211', namespace: 'test'
  end

  it 'Verify the response of index is correct' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it 'Verify cache content is correct' do
    get '/cache'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it 'Verify cache content is correct' do
    get '/cache'
    expect(Marshal.load(@client['cache', true])).to eq('Hello World')
  end

  it 'Readable only without block' do
    get '/cache'
    get '/read'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end
end

describe 'Sinatra-MemCache exires and compress' do
  before do
    @client = MemCache.new 'localhost:11211', namespace: 'test'
  end

  it 'Verify that cach can be expired' do
    get '/cache'
    get '/expire'
    expect(@client['cache']).to be_nil
  end

  it 'Expire cache after valid amount of time' do
    get '/cache2'
    sleep(1)
    expect(@client['cache2']).to be_nil
  end

  it 'Expire all the things' do
    get '/cache'
    get '/cache2'
    get '/compress'
    get '/expire_re'
    expect(@client['cache']).to be_nil
    expect(@client['cache2']).to be_nil
    expect(@client['compress']).to be_nil
  end
end

describe 'Sinatra-MemCache exires and compress' do
  before do
    @client = MemCache.new 'localhost:11211', namespace: 'test'
  end
  it 'Verify compress is working' do
    get '/compress'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello Compress')
    expect(@client['compress', true]).to \
      eq(Zlib::Deflate.deflate(Marshal.dump('Hello Compress')))
  end

  it 'Cache the object' do
    get '/object'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('hello a hello b')
    expect(Marshal.load(@client['object', true])).to \
      eq(a: 'hello a', b: 'hello b')
  end
end
