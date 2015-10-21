require 'ostruct'
require 'spec_helper'
require 'apill/requests/base'

module    Apill
module    Requests
describe  Base do
  it 'can resolve itself by returning itself' do
    raw_request      = Base.new(token_private_key: '', request: {})
    resolved_request = Base.resolve(raw_request)

    expect(resolved_request).to eql raw_request
  end

  it 'can resolve a Rails request' do
    raw_request      = OpenStruct.new(
                         headers: {},
                         params:  {})
    resolved_request = Base.resolve(raw_request)

    expect(resolved_request).to be_a Requests::Rails
  end

  it 'can resolve a Rack request' do
    raw_request      = {
      'HTTP_ACCEPT'  => 'accept_string',
      'QUERY_STRING' => '',
    }
    resolved_request = Base.resolve(raw_request)

    expect(resolved_request).to be_a Requests::Rack
  end
end
end
end
