require File.dirname(__FILE__) + '/fixture'
require 'rack/test'

include Rack::Test::Methods
def app
  Sinatra::Application
end

describe Rack do
  before do
    @client = MemCache.new 'localhost:11211', :namespace => "test"
  end

  it "indexのレスポンスが正しいこと" do
    get '/'
    last_response.ok?.should be_true
    last_response.body.should == "Hello World"
  end

  it "cacheしたときのレスポンスが正しいこと" do
    get '/cache'
    last_response.ok?.should be_true
    last_response.body.should == "Hello World"
  end

  it "cacheした内容が正しいこと" do
    get '/cache'
    @client['cache', true].should == "Hello World"
  end

  it "cacheした内容がexpireされること" do
    get '/cache'
    get '/expire'
    @client['cache', true].should be_nil
  end

  it "cacheが有効時間後にexpireされること" do
    get '/cache2'
    @client['cache2'].should == "Hello World"
    sleep(1)
    @client['cache2'].should be_nil
  end

  it "全てのcacheがexpireされること" do
    get '/cache'
    get '/cache2'
    get '/expire_re'
    @client['cache', true].should be_nil
    @client['cache2'].should be_nil
  end
end
