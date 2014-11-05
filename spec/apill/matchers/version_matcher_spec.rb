require 'ostruct'
require 'rspectacular'
require 'apill/matchers/version_matcher'

module    Apill
module    Matchers
describe  VersionMatcher do
  it 'raises an error when the accept header is not valid' do
    request = OpenStruct.new(headers:     { 'Accept' => 'matrix' },
                             subdomains:  [ 'api' ],
                             params:      {})

    matcher = VersionMatcher.new

    expect { matcher.matches?(request) }.to raise_error Apill::Errors::InvalidApiRequestError
  end

  context 'when the version is passed in the accept header' do
    it 'does not match if the subdomain is not API but the request version is equal to the version constraint' do
      request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion;version=10.0' },
                               subdomains:  [ 'not-api' ],
                               params:      {})

      matcher = VersionMatcher.new(application:        'matrix',
                                   version_constraint: '10.0')

      expect(matcher.matches?(request)).to be_falsey
    end

    it 'does not match if the subdomain is API but the requested version does not equal the version constraint' do
      request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion;version=10.0' },
                               subdomains:  [ 'api' ],
                               params:      {})

      matcher = VersionMatcher.new(application:        'matrix',
                                   version_constraint: '10.1')

      expect(matcher.matches?(request)).to be_falsey
    end

    it 'does match if the subdomain is API and the requested version equals the version constraint' do
      request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion;version=10.0' },
                               subdomains:  [ 'api' ],
                               params:      {})

      matcher = VersionMatcher.new(application:        'matrix',
                                   version_constraint: '10.0')

      expect(matcher.matches?(request)).to be_truthy
    end
  end

  context 'when the version is not passed in the accept header' do
    it 'does not match if the subdomain is not API but the request version is equal to the version constraint' do
      request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion' },
                               subdomains:  [ 'not-api' ],
                               params:      {})

      matcher = VersionMatcher.new(application:        'matrix',
                                   version_constraint: '10.0',
                                   default_version:    '10.0')

      expect(matcher.matches?(request)).to be_falsey
    end

    it 'does not match if the subdomain is API but the requested version does not equal the version constraint' do
      request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion' },
                               subdomains:  [ 'api' ],
                               params:      {})

      matcher = VersionMatcher.new(application:        'matrix',
                                   version_constraint: '10.1',
                                   default_version:    '10.0')

      expect(matcher.matches?(request)).to be_falsey
    end

    it 'does match if the subdomain is API and the requested version equals the version constraint' do
      request = OpenStruct.new(headers:     { 'Accept' => 'application/vnd.matrix+zion' },
                               subdomains:  [ 'api' ],
                               params:      {})

      matcher = VersionMatcher.new(application:        'matrix',
                                   version_constraint: '10.0',
                                   default_version:    '10.0')

      expect(matcher.matches?(request)).to be_truthy
    end
  end
end
end
end
