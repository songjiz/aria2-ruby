require 'json'
require 'net/https'
require 'uri'
require 'base64'
require 'aria2/response'
require 'aria2/error'

module Aria2
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
      "#{protocol}://#{host}:#{port}/jsonrpc"
    end

    def protocol
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
        verb = verb.to_s.gsub(/(?:_+)([a-z])/) { $1.upcase }
        raise_on_error = !verb.chomp!('!').nil?
        uri = URI(rpc_url)
        uri.query = URI.encode_www_form(
          jsonrpc: RPC_VERSION,
          id: "#{Time.now.to_i}",
          method: "aria2.#{verb}",
          params: build_params(*args)
        )
        http_response = ::Net::HTTP.get_response(uri)
        response = Response.new(http_response)
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

      # Base64-encoded JSON array
      def build_params(*args)
        params = ["token:#{@token}", args]
        Base64.encode64 JSON.dump(params)
      end

  end
end
