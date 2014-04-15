require 'ostruct'
require 'rspectacular'
require 'apill/matchers/accept_header_matcher'

module    Apill
module    Matchers
describe  AcceptHeaderMatcher do
  it 'matches if the subdomain is API and the accept header is valid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion;version=1.0.0' },
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_truthy
  end

  it 'does not match if the subdomain is not API but the accept header is valid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion' },
                             subdomains:  [ 'not-api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_falsey
  end

  it 'does not match if the subdomain is API but the accept header is invalid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.' },
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_falsey
  end

  it 'does not match if neither the subdomain is API nor the accept header is valid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.' },
                             subdomains:  [ 'not-api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_falsey
  end
end
end
end
