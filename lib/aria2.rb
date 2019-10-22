require 'aria2/version'
require 'aria2/client'

module Aria2
  def self.with(options = {}, &block)
    client = Client.new(options)
    if block_given?
      if block.arity > 0
        yield client
      else
        client.instance_eval &block
      end
    else
      client
    end
  end
end
