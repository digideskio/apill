require 'ostruct'
require 'rspectacular'
require 'apill/matchers/invalid_api_request_matcher'

module    Apill
module    Matchers
describe  InvalidApiRequestMatcher do
  it 'is the inverse of whether the accept header matches' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion;version=1.0.0' },
                             subdomains:  [ 'api' ])

    matcher = InvalidApiRequestMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_falsey
  end
end
end
end
