require 'rspectacular'
require 'apill/requests/rack_request'

module    Apill
module    Requests
describe  RackRequest do
  it 'finds the accept header from the headers if it is valid' do
    raw_request = {
      'HTTP_ACCEPT'             => 'application/vnd.matrix+zion;version=10.0',
      'QUERY_STRING'            => '',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request     = RackRequest.new(raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the headers if it is invalid but there is no ' \
     'accept header in the params' do

    raw_request = {
      'HTTP_ACCEPT'             => 'invalid/vnd.matrix+zion;version=10.0',
      'QUERY_STRING'            => '',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request     = RackRequest.new(raw_request)

    expect(request.accept_header.to_s).to eql 'invalid/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the params if it is valid' do
    raw_request = {
      'HTTP_ACCEPT'             => '',
      'QUERY_STRING'            => 'accept=application/vnd.matrix+zion;version=10.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request     = RackRequest.new(raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  it 'defaults to the application name in the configuration if none is found in ' \
     'the header' do

    Apill.configuration.application_name = 'zion'

    raw_request = {
      'HTTP_ACCEPT'  => '',
      'QUERY_STRING' => 'accept=application/vnd.zion+zion;version=10.0',
    }
    request     = RackRequest.new(raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.zion+zion;version=10.0'
  end
end
end
end
