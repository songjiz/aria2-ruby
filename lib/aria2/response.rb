require 'json'

module Aria2
  class Response

    def initialize(http_response)
      @http_response = http_response
    end

    def [](key)
      payload[key]
    end

    def payload
      @payload ||= JSON.parse(@http_response.body)
    end

    def error?
      payload.key? 'error'
    end

    def ok?
      !error?
    end

    def to_h
      payload
    end

    %i(id jsonrpc error result).each do |item|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{item}
          payload['#{item}']
        end
      RUBY
    end

  end
end
