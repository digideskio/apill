require 'rspectacular'
require 'apill/matchers/subdomain_matcher'

module    Apill
module    Matchers
describe  SubdomainMatcher do
  it 'matches if the subdomain is API' do
    matcher = SubdomainMatcher.new
    request = { 'HTTP_HOST' => 'api.example.com' }

    expect(matcher.matches?(request)).to be_a TrueClass
  end

  it 'matches if the first subdomain is API' do
    matcher = SubdomainMatcher.new
    request = { 'HTTP_HOST' => 'api.matrix.example.com' }

    expect(matcher.matches?(request)).to be_a TrueClass
  end

  it 'does not match if the first subdomain is not API' do
    matcher = SubdomainMatcher.new
    request = { 'HTTP_HOST' => 'matrix.example.com' }

    expect(matcher.matches?(request)).to be_a FalseClass
  end

  it 'allows the matched subdomain to be specified' do
    matcher = SubdomainMatcher.new(allowed_subdomains: 'matrix')
    request = { 'HTTP_HOST' => 'matrix.example.com' }

    expect(matcher.matches?(request)).to be_a TrueClass
  end

  it 'allows more than one subdomain to be matched' do
    matcher = SubdomainMatcher.new(allowed_subdomains: %w{api matrix})

    request = { 'HTTP_HOST' => 'matrix.example.com' }
    expect(matcher.matches?(request)).to be_a TrueClass

    request = { 'HTTP_HOST' => 'api.example.com' }
    expect(matcher.matches?(request)).to be_a TrueClass
  end
end
end
end
