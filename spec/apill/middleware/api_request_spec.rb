require 'rspectacular'
require 'apill/middleware/api_request'

module    Apill
module    Middleware
describe  ApiRequest do
  let(:app) { lambda { |env| [200, {}, 'response'] } }

  before(:each) do
    HumanError.configure do |config|
      config.api_error_documentation_url = 'http://error.com'
      config.knowledgebase_url           = 'http://knowledge.com'
      config.api_version                 = '1'
    end

    Apill.configure do |config|
      config.allowed_subdomains = %w{api}
      config.application_name   = 'matrix'
    end
  end

  it 'does not allow requests if they are not for an allowed subdomain' do
    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'               => 'notvalid.example.com',
      'HTTP_ACCEPT'             => '',
      'QUERY_STRING'            => 'first=my_param&accept=application/vnd.silent+zion;version=1.0.0',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to   eql 404
    expect(headers).to  eql Hash.new
    expect(response).to eql(
      [
        '{' \
          '"error":' \
          '{' \
            '"status":404,' \
            '"code":1010,' \
            '"developer_documentation_uri":"http://error.com/1010?version=1",' \
            '"customer_support_uri":"http://knowledge.com/1234567890",' \
            '"developer_message_key":"errors.invalid.subdomain.error.developer",' \
            '"developer_message":"The resource you attempted to access is either not authorized for the authenticated user or does not exist.",' \
            '"developer_details":' \
              '{' \
                '"http_host":"notvalid.example.com"' \
              '},' \
            '"friendly_message_key":"errors.invalid.subdomain.error.friendly",' \
            '"friendly_message":"Sorry! The resource you tried to access does not exist."' \
          '}' \
        '}'
      ]
    )
  end

  it 'does not allow requests if they are for an allowed subdomain but does ' \
     'not have a valid accept header' do

    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'               => 'api.example.com',
      'HTTP_ACCEPT'             => '',
      'QUERY_STRING'            => 'first=my_param&accept=application/vnd.silent+zion;version=1.0.0',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to   eql 400
    expect(headers).to  eql Hash.new
    expect(response).to eql(
      [
        '{' \
          '"error":' \
          '{' \
            '"status":400,' \
            '"code":1007,' \
            '"developer_documentation_uri":"http://error.com/1007?version=1",' \
            '"customer_support_uri":"http://knowledge.com/1234567890",' \
            '"developer_message_key":"errors.invalid.api.request.error.developer",' \
            '"developer_message":"The accept header that you passed in the request cannot be parsed, please refer to the documentation to verify.",' \
            '"developer_details":' \
              '{' \
                '"accept_header":""' \
              '},' \
            '"friendly_message_key":"errors.invalid.api.request.error.friendly",' \
            '"friendly_message":"Sorry! We couldn\'t understand what you were trying to ask us to do."' \
          '}' \
        '}'
      ]
    )
  end

  it 'does allow requests if both the subdomain and the accept header are valid' do
    api_request_middleware = ApiRequest.new(app)

    request = {
      'HTTP_HOST'               => 'api.example.com',
      'HTTP_ACCEPT'             => 'application/vnd.matrix+zion;version=1.0.0',
      'QUERY_STRING'            => 'first=my_param&accept=application/vnd.matrix+zion;version=1.0.0',
    }

    status, headers, response = api_request_middleware.call(request)

    expect(status).to   eql 200
    expect(headers).to  eql Hash.new
    expect(response).to eql 'response'
  end
end
end
end
