require 'ostruct'
require 'rspectacular'
require 'apill/matchers/invalid_api_request_matcher'

module    Apill
module    Matchers
describe  InvalidApiRequestMatcher do
  it 'is the inverse of whether the accept header matches' do
    request = {
      'HTTP_HOST'            => 'api.example.com',
      'HTTP_ACCEPT'          => 'application/vnd.matrix+zion;version=1.0.0',
      'API_APPLICATION_NAME' => 'matrix',
    }

    matcher = InvalidApiRequestMatcher.new

    expect(matcher.matches?(request)).to be_a FalseClass
  end
end
end
end
