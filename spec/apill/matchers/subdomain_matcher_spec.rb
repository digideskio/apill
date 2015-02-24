require 'rspectacular'
require 'apill/matchers/subdomain_matcher'
require 'apill/configuration'

module    Apill
module    Matchers
describe  SubdomainMatcher do
  before(:each) do
    Apill.configuration.allowed_subdomains     = %w{api}
  end

  it 'matches if the subdomain is API' do
    request = { 'HTTP_HOST' => 'api.example.com' }
    matcher = SubdomainMatcher.new(request: request)

    expect(matcher.matches?).to be_a TrueClass
  end

  it 'matches if the first subdomain is API' do
    request = { 'HTTP_HOST' => 'api.matrix.example.com' }
    matcher = SubdomainMatcher.new(request: request)

    expect(matcher.matches?).to be_a TrueClass
  end

  it 'does not match if the first subdomain is not API' do
    request = { 'HTTP_HOST' => 'matrix.example.com' }
    matcher = SubdomainMatcher.new(request: request)

    expect(matcher.matches?).to be_a FalseClass
  end

  it 'allows the matched subdomain to be specified' do
    request = { 'HTTP_HOST' => 'matrix.example.com' }
    matcher = SubdomainMatcher.new(allowed_subdomains: 'matrix',
                                   request:            request)

    expect(matcher.matches?).to be_a TrueClass
  end

  it 'allows more than one subdomain to be matched' do
    request = { 'HTTP_HOST' => 'matrix.example.com' }
    matcher = SubdomainMatcher.new(allowed_subdomains: %w{api matrix},
                                   request:            request)

    expect(matcher.matches?).to be_a TrueClass

    request = { 'HTTP_HOST' => 'api.example.com' }
    matcher = SubdomainMatcher.new(allowed_subdomains: %w{api matrix},
                                   request:            request)

    expect(matcher.matches?).to be_a TrueClass
  end
end
end
end
