require 'spec_helper'

describe Aria2 do
  before(:all) do
    @client = Aria2::Client.new
  end

  it 'getVersion' do
    response = @client.getVersion
    expect(response.result).to include('version')
  end

  it 'getVersion!' do
    expect { @client.getVersion! }.not_to raise_error
  end
end
