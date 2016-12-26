require 'json'
require 'net/http'
require 'uri'
require 'base64'
require 'aria2/response'
require 'aria2/error'
module Aria2
  # Aria2 JSON RPC Client
  #
  # Method: https://aria2.github.io/manual/en/html/aria2c.html#methods
  # - addUri(*uris)
  # - addTorrent(torrent)
  #   torrent is the contents of the ".torrent" file
  # - addMetalink(metalink)
  # - remove(gid)
  # - forceRemove(gid)
  # - pause(gid)
  # - pauseAll
  # - forcePause(gid)
  # - forcePauseAll
  # - unpause(gid)
  # - unpauseAll
  # - tellStatus(gid)
  # - getUris(gid)
  # - getFiles(gid)
  # - getPeers(gid)
  # - getServers(gid)
  # - tellActive
  # - tellWaiting(offset, num)
  # - tellStopped(offset, num)
  # - changePosition(gid, pos, how)
  # - changeUri(gid, fileIndex, delUris, addUris)
  # - getOption(gid)
  # - changeOption(gid, options)
  # - getGlobalOption
  # - changeGlobalOption(options)
  # - getGlobalStat
  # - purgeDownloadResult
  # - removeDownloadResult(gid)
  # - getVersion
  # - shutdown
  # - forceShutdown
  # - saveSession
  #
  class Client

    DEFAULT_HOST = 'localhost'.freeze
    DEFAULT_PORT = 6800.freeze
    RPC_VERSION  = '2.0'.freeze

    attr_reader :host, :port

    def initialize(options = {})
      @host   = options.fetch(:host, DEFAULT_HOST)
      @port   = options.fetch(:port, DEFAULT_PORT)
      @secure = options[:secure]
      @token  = options[:token]
    end

    def rpc_url
      "#{schema}://#{host}:#{port}/jsonrpc"
    end

    def schema
      secure? ? :https : :http
    end

    def secure?
      !!@secure
    end

    def token?
      !!@token
    end

    private

      def method_missing(verb, *args, &block)
        request verb, *args, &block
      end

      def request(verb, *args, &block)
        verb = verb.to_s
        # If {verb} end with '!', when the JSON RPC response contain 'error' key,
        # then raise Aria2::Error
        raise_on_error = !verb.chomp!('!').nil?
        paylod = ({
          jsonrpc: RPC_VERSION,
          id: "#{Time.now.to_i}",
          method: "aria2.#{verb}",
          params: build_params(*args)
        })
        uri = URI rpc_url
        uri.query = URI.encode_www_form paylod
        http_response = ::Net::HTTP.get_response uri
        response  = Response.new http_response
        if response.error? && raise_on_error
          raise Aria2::Error.from_response(response)
        else
          if block_given?
            yield response
          else
            response
          end
        end
      end

      def build_params(*args)
        params = ["token:#{@token}", args]
        # The params parameter is Base64-encoded JSON array
        Base64.encode64 JSON.dump(params)
      end

  end # Client
end # Aria2
