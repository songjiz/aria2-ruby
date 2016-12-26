require 'spec_helper'

describe Aria2 do

  before(:all) do
    @client = Aria2::Client.new token: 'your_token'
  end

  it 'getVersion' do
    response = @client.getVersion
    expect(response['error']['code']).to eql 1
  end

  it 'getVersion!' do
    expect { @client.getVersion! }.to raise_error(Aria2::Error)
  end

end
