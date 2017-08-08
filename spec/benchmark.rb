require 'rubygems'
require 'memcache'
require 'zlib'
require 'benchmark'

CACHE = MemCache.new 'localhost:11211', namespace: 'bench'
def set(key, value, flg)
  value = Zlib::Deflate.deflate(Marshal.dump(value)) if flg
  CACHE.set(key, value, 0, true)
end

def get(key, flg)
  value = CACHE[key, true]
  if flg
    Marshal.load(Zlib::Inflate.inflate(value))
  else
    value
  end
end

Benchmark.bm(17) do |x|
  x.report('no compress set:') do
    5000.times do |i|
      set(i.to_s, i, false)
    end
  end
  x.report('no compress get:') do
    5000.times do |i|
      get(i.to_s, false)
    end
  end

  x.report('compress set:') do
    5000.times do |i|
      set(i.to_s, i, true)
    end
  end
  x.report('compress get:') do
    5000.times do |i|
      get(i.to_s, true)
    end
  end
end
