require 'memcache'
require 'zlib'

#
class MemCache
  def all_keys
    raise MemCacheError, 'No active servers' unless active?
    keys = []

    @servers.each do |server|
      sock = server.socket
      raise MemCacheError, 'No connection to server' if sock.nil?

      begin
        sock.write "stats items\r\n"
        slabs = {}
        while line = sock.gets
          break if line == "END\r\n"
          slabs[Regexp.last_match(1)] = Regexp.last_match(2) if \
            line =~ /^STAT items:(\d+):number (\d+)/
        end

        slabs.each do |k, v|
          sock.write "stats cachedump #{k} #{v}\r\n"
          while line = sock.gets
            break if line == "END\r\n"
            prefix = @namespace.empty? ? '' : "#{@namespace}:"
            r = Regexp.new("^ITEM #{prefix}([^\s]+)")
            keys << Regexp.last_match(1) if line =~ r
          end
        end
      rescue SocketError, SystemCallError, IOError => err
        server.close
        raise MemCacheError, err.message
      end
    end

    keys
  end
end

#
module Sinatra
  #
  module MemCache
    #
    module Helpers
      #
      def cache(key, params = {})
        return yield unless settings.cache_enable

        opts = {
          expiry: settings.cache_default_expiry,
          compress: settings.cache_default_compress
        }.merge(params)

        value = get(key, opts)
        return value unless block_given?

        if value
          log "Get: #{key}"
          value
        else
          log "Set: #{key}"
          set(key, yield, opts)
        end
      rescue => e
        throw e if development?
        yield
      end

      #
      def expire(p)
        return unless settings.cache_enable
        case p
        when String
          expire_key(p)
        when Regexp
          expire_regexp(p)
        end
        true
      rescue => e
        throw e if development?
        false
      end

      private

      def client
        settings.cache_client ||= ::MemCache.new settings.cache_server,
                                                 namespace: \
                                                 settings.cache_namespace
      end

      def log(msg)
        puts "[sinatra-memcache] #{msg}" if settings.cache_logging
      end

      def get(key, opts)
        v = client[key, true]
        return v unless v

        v = Zlib::Inflate.inflate(v) if opts[:compress]
        Marshal.load(v)
      end

      def set(key, value, opts)
        v = Marshal.dump(value)
        v = Zlib::Deflate.deflate(v) if opts[:compress]
        client.set(key, v, opts[:expiry], true)
        value
      end

      def expire_key(key)
        client.delete(key)
        log "Expire: #{key}"
      end

      def expire_regexp(re)
        keys = client.all_keys
        keys.each do |key|
          expire_key(key) if key =~ re
        end
      end
    end

    def self.registered(app)
      app.helpers MemCache::Helpers

      app.set :cache_client, nil
      app.set :cache_server, 'localhost:11211'
      app.set :cache_namespace, 'sinatra-memcache'
      app.set :cache_enable, true
      app.set :cache_logging, true
      app.set :cache_default_expiry, 3600
      app.set :cache_default_compress, false
    end
  end

  register MemCache
end
