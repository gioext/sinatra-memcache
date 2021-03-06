require File.dirname(__FILE__) + '/fixture'
require 'rack/test'

include Rack::Test::Methods
def app
  Sinatra::Application
end

describe 'Sinatra-MemCache' do
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
    Marshal.load(@client['cache', true]).should == "Hello World"
  end

  it "ブロック無しで読み取りのみできること" do
    get '/cache'
    get '/read'
    last_response.ok?.should be_true
    last_response.body.should == "Hello World"
  end

  it "cacheした内容がexpireされること" do
    get '/cache'
    get '/expire'
    @client['cache'].should be_nil
  end

  it "cacheが有効時間後にexpireされること" do
    get '/cache2'
    sleep(1)
    @client['cache2'].should be_nil
  end

  it "compressが有効であること" do
    get '/compress'
    last_response.ok?.should be_true
    last_response.body.should == "Hello Compress"
    @client['compress', true].should == Zlib::Deflate.deflate(Marshal.dump('Hello Compress'))
  end

  it "オブジェクトがcacheされること" do
    get '/object'
    last_response.ok?.should be_true
    last_response.body.should == "hello a hello b"
    Marshal.load(@client['object', true]).should == { :a => 'hello a', :b => 'hello b' }
  end

  it "全てのcacheがexpireされること" do
    get '/cache'
    get '/cache2'
    get '/compress'
    get '/expire_re'
    @client['cache'].should be_nil
    @client['cache2'].should be_nil
    @client['compress'].should be_nil
  end
end
