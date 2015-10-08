require 'spec_helper'
require 'apill/middleware/api_request'

module    Apill
module    Middleware
describe  ApiRequest, singletons: HumanError::Configuration do
  let(:app) { ->(_env) { [200, {}, 'response'] } }

  before(:each) do
    HumanError.configuration.url_mappings = {
      'external_documentation_urls'  => {
        'errors.responses.invalid_subdomain' => 'http://example.com/foo',
      },
      'developer_documentation_urls' => {
        'errors.responses.invalid_subdomain' => 'http://example.com/foo',
      },
    }

    Apill.configure do |config|
      config.allowed_subdomains     = %w{api matrix}
      config.allowed_api_subdomains = %w{api}
      config.application_name       = 'matrix'
    end
  end

  it 'allows requests for allowed subdomains without accept headers' do
    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'    => 'matrix.example.com',
      'HTTP_ACCEPT'  => '',
      'QUERY_STRING' => '',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to   eql 200
    expect(headers).to  eql({})
    expect(response).to eql 'response'
  end

  it 'does not allow requests if they are not for an allowed subdomain' do
    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'    => 'notvalid.example.com',
      'HTTP_ACCEPT'  => '',
      'QUERY_STRING' => 'first=my_param&accept=application/vnd.silent+zion;version=1.0.0',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to                 eql 404
    expect(headers).to                eql({})
    expect(JSON.load(response[0])).to include(
      'errors' => [
        {
          'id'     => match(/[a-z0-9\-]+/),
          'links'  => {
            'about'         => nil,
            'documentation' => nil,
          },
          'status' => 404,
          'code'   => 'errors.invalid_subdomain',
          'title'  => 'Invalid Subdomain',
          'detail' => 'The resource you attempted to access is either not authorized ' \
                      'for the authenticated user or does not exist.',
          'source' => {
            'http_host' => 'notvalid.example.com',
          },
        },
      ],
    )
  end

  it 'does not allow requests if they are for an allowed subdomain but does ' \
     'not have a valid accept header' do

    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'    => 'api.example.com',
      'HTTP_ACCEPT'  => '',
      'QUERY_STRING' => 'first=my_param&accept=application/vnd.silent+zion;version=1.0.0',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to                 eql 400
    expect(headers).to                eql({})
    expect(JSON.load(response[0])).to include(
      'errors' => [
        {
          'id'     => match(/[a-z0-9\-]+/),
          'links'  => {
            'about'         => nil,
            'documentation' => nil,
          },
          'status' => 400,
          'code'   => 'errors.invalid_api_request',
          'title'  => 'Invalid API Request',
          'detail' => 'The accept header that you passed in the request cannot be ' \
                      'parsed, please refer to the documentation to verify.',
          'source' => {
            'accept_header' => '',
          },
        },
      ],
    )
  end

  it 'does allow requests if both the subdomain and the accept header are valid' do
    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'    => 'api.example.com',
      'HTTP_ACCEPT'  => 'application/vnd.matrix+zion;version=1.0.0',
      'QUERY_STRING' => 'first=my_param&accept=application/vnd.matrix+zion;version=1.0.0',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to   eql 200
    expect(headers).to  eql({})
    expect(response).to eql 'response'
  end

  it 'does allow requests if the subdomain, the accept header and the token are valid' do
    Apill.configuration.token_private_key = test_private_key
    api_request_middleware                = ApiRequest.new(app)

    request = {
      'HTTP_HOST'          => 'api.example.com',
      'HTTP_ACCEPT'        => 'application/vnd.matrix+zion;version=1.0.0',
      'HTTP_AUTHORIZATION' => "Token #{valid_token}",
      'QUERY_STRING'       => 'accept=application/vnd.matrix+zion;version=1.0.0',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to   eql 200
    expect(headers).to  eql({})
    expect(response).to eql 'response'
  end

  it 'returns the proper response if the token is invalid' do
    Apill.configuration.token_private_key = test_private_key
    api_request_middleware                = ApiRequest.new(app)

    request = {
      'HTTP_HOST'          => 'api.example.com',
      'HTTP_ACCEPT'        => 'application/vnd.matrix+zion;version=1.0.0',
      'HTTP_AUTHORIZATION' => "Token #{invalid_token}",
      'QUERY_STRING'       => 'accept=application/vnd.matrix+zion;version=1.0.0',
    }

    _status, _headers, response = api_request_middleware.call(request)

    expect(response.first).to include 'errors.invalid_token'
  end

  it 'converts JSON API compliant dasherized query params to underscored' do
    app                    = ->(env) { [200, env, 'response'] }
    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'    => 'api.example.com',
      'HTTP_ACCEPT'  => 'application/vnd.matrix+zion;version=1.0.0',
      'QUERY_STRING' => 'hello-there=bob-jones&'     \
                        'nice-to-meet=you-bob&'      \
                        'hows-the-weather=today-bob',
    }

    _status, headers, _response = api_request_middleware.call(request)

    expect(headers['QUERY_STRING']).to eql 'hello_there=bob-jones&' \
                                           'nice_to_meet=you-bob&'  \
                                           'hows_the_weather=today-bob'
  end
end
end
end
