require 'rspectacular'
require 'apill/responses/invalid_subdomain_response'

module    Apill
module    Responses
describe  InvalidSubdomainResponse do
  before(:each) do
    HumanError.configuration.api_error_documentation_url = 'http://error.com'
    HumanError.configuration.knowledgebase_url           = 'http://knowledge.com'
    HumanError.configuration.api_version                 = '1'
  end

  it 'returns the proper response' do
    request  = { 'HTTP_HOST' => 'api.example.com' }
    response = InvalidSubdomainResponse.call(request)

    expect(response).to eql(
      [
        404,
        {},
        [
          '{' \
            '"error":' \
            '{' \
              '"status":404,' \
              '"code":1010,' \
              '"developer_documentation_uri":"http://error.com/1010?version=1",' \
              '"customer_support_uri":"http://knowledge.com/1234567890",' \
              '"developer_message_key":"errors.invalid.subdomain.error.developer",' \
              '"developer_message":"The resource you attempted to access is either not ' \
                                   'authorized for the authenticated user or does not ' \
                                   'exist.",' \
              '"developer_details":' \
                '{' \
                  '"http_host":"api.example.com"' \
                '},' \
              '"friendly_message_key":"errors.invalid.subdomain.error.friendly",' \
              '"friendly_message":"Sorry! The resource you tried to access does not ' \
                                  'exist."' \
            '}' \
          '}',
        ],
      ],
    )
  end
end
end
end
