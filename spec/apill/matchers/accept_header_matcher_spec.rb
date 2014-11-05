require 'ostruct'
require 'rspectacular'
require 'apill/matchers/accept_header_matcher'

module    Apill
module    Matchers
describe  AcceptHeaderMatcher do
  it 'matches if the subdomain is API and the accept header is valid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion;version=1.0.0' },
                             params:      {},
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_truthy
  end

  it 'matches if the subdomain is API and the accept header is passed in as a parameter' do
    request = OpenStruct.new(headers:     {},
                             params:      { 'accept' => 'application/vnd.matrix+zion;version=1.0.0'  },
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_truthy
  end

  it 'matches the header accept header if the subdomain is API and the accept header is passed both as a valid header and as a parameter' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion;version=1.0.0' },
                             params:      { 'accept' => 'application/vnd.matrix+zion;version=2.0.0'  },
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')
    matcher.matches?(request)

    expect(matcher.accept_header.version).to eql '1.0.0'
  end

  it "matches the parameter's accept header if the subdomain is API and the accept header is passed both as an invalid header as well as as a parameter" do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vndmatrix+zion;version=1.0.0' },
                             params:      { 'accept' => 'application/vnd.matrix+zion;version=2.0.0'  },
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')
    matcher.matches?(request)

    expect(matcher.accept_header.version).to eql '2.0.0'
  end

  it "matches the parameter's accept header if the subdomain is API and the accept header is passed both as an invalid header as well as as a parameter" do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vndmatrix+zion;version=1.0.0' },
                             params:      {},
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')
    matcher.matches?(request)

    expect(matcher.accept_header.raw_accept_header).to eql 'application/vndmatrix+zion;version=1.0.0'
  end

  it 'does not match if the subdomain is not API but the accept header is valid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion' },
                             params:      {},
                             subdomains:  [ 'not-api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_falsey
  end

  it 'does not match if the subdomain is API but the accept header is invalid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.' },
                             params:      {},
                             subdomains:  [ 'api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_falsey
  end

  it 'does not match if neither the subdomain is API nor the accept header is valid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.' },
                             params:      {},
                             subdomains:  [ 'not-api' ])

    matcher = AcceptHeaderMatcher.new(application: 'matrix')

    expect(matcher.matches?(request)).to be_falsey
  end
end
end
end
