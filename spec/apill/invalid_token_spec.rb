require 'spec_helper'
require 'apill/responses/invalid_token'

module    Apill
module    Responses
describe  InvalidToken, singletons: HumanError::Configuration do
  it 'returns the proper response' do
    HumanError.configuration.url_mappings = {
      'external_documentation_urls'  => {
        'errors.responses.invalid_token' => 'http://example.com/foo',
      },
      'developer_documentation_urls' => {
        'errors.responses.invalid_token' => 'http://example.com/foo',
      },
    }

    request                   = { 'HTTP_HOST' => 'api.example.com' }
    status, headers, response = InvalidToken.call(request, application_name: 'my_app')

    expect(status).to                 eql 401
    expect(headers).to                eql('WWW-Authenticate' => 'Token realm="my_app"')
    expect(JSON.load(response[0])).to include(
      'errors'              => [
        include(
          'id'     => match(/[a-f0-9\-]+/),
          'links'  => {
            'about'         => nil,
            'documentation' => nil,
          },
          'status' => 401,
          'code'   => 'errors.invalid_token',
          'title'  => 'Invalid or Unauthorized Token',
          'detail' => 'Either the token you passed is invalid or is not allowed to ' \
                      'perform this action.',
          'source' => {},
        ),
      ],
    )
  end
end
end
end
