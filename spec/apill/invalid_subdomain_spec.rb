require 'spec_helper'
require 'apill/responses/invalid_subdomain'

module    Apill
module    Responses
describe  InvalidSubdomain, singletons: HumanError::Configuration do
  it 'returns the proper response' do
    HumanError.configuration.url_mappings = {
      'external_documentation_urls'  => {
        'errors.responses.invalid_subdomain' => 'http://example.com/foo',
      },
      'developer_documentation_urls' => {
        'errors.responses.invalid_subdomain' => 'http://example.com/foo',
      },
    }

    request                   = { 'HTTP_HOST' => 'api.example.com' }
    status, headers, response = InvalidSubdomain.call(request)

    expect(status).to                 eql 404
    expect(headers).to                eql({})
    expect(JSON.load(response[0])).to include(
      'errors'              => [
        include(
          'id'     => match(/[a-f0-9\-]+/),
          'links'  => {
            'about'         => nil,
            'documentation' => nil,
          },
          'status' => 404,
          'code'   => 'errors.invalid_subdomain_error',
          'title'  => 'Invalid Subdomain',
          'detail' => 'The resource you attempted to access is either not authorized ' \
                      'for the authenticated user or does not exist.',
          'source' => {
            'http_host'     => 'api.example.com',
          },
        ),
      ],
    )
  end
end
end
end
