module Aria2
  class Error < StandardError

    def self.from_response(response)
      error = response.error
      new(error['code'], error['message'])
    end

    attr_reader :code, :message

    def initialize(code, message)
      @code    = code
      @message =  message
    end

    def to_h
      { code: code, message: message }
    end

  end # Error
end # Aria2
