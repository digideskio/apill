require 'ostruct'
require 'spec_helper'
require 'apill/requests/rails_request'

module    Apill
module    Requests
describe  RailsRequest do
  it 'finds the accept header from the headers if it is valid' do
    raw_request = OpenStruct.new(
                    headers: {
                      'X-Application-Name' => 'matrix',
                      'Accept'             => 'application/vnd.matrix+zion;version=10.0',
                    },
                    params:  {})
    request     = RailsRequest.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the headers if it is invalid but there is no ' \
     'accept header in the params' do

    raw_request = OpenStruct.new(
                    headers: {
                      'X-Application-Name' => 'matrix',
                      'Accept'             => 'invalid/vnd.matrix+zion;version=10.0',
                    },
                    params:  {})
    request     = RailsRequest.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'invalid/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the params if it is valid' do
    raw_request = OpenStruct.new(
                    headers: {
                      'X-Application-Name' => 'matrix',
                    },
                    params:  { 'accept' => 'application/vnd.matrix+zion;version=10.0' })
    request     = RailsRequest.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  it 'defaults to the application name in the configuration if none is found in ' \
     'the header' do

    Apill.configuration.application_name = 'zion'

    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'accept' => 'application/vnd.zion+zion;version=10.0' })
    request     = RailsRequest.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.zion+zion;version=10.0'
  end
end
end
end
