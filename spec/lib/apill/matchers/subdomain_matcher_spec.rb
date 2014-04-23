require 'ostruct'
require 'rspectacular'
require 'apill/matchers/subdomain_matcher'

module    Apill
module    Matchers
describe  SubdomainMatcher do
  it 'matches if the subdomain is API' do
    request = OpenStruct.new(subdomains:  [ 'api' ])

    matcher = SubdomainMatcher.new

    expect(matcher.matches?(request)).to be_truthy
  end

  it 'matches if the first subdomain is API' do
    request = OpenStruct.new(subdomains:  [ 'api', 'matrix' ])

    matcher = SubdomainMatcher.new

    expect(matcher.matches?(request)).to be_truthy
  end

  it 'does not match if the first subdomain is not API' do
    request = OpenStruct.new(subdomains:  [ 'matrix' ])

    matcher = SubdomainMatcher.new

    expect(matcher.matches?(request)).to be_falsey
  end

  it 'allows the matched subdomain to be specified' do
    request = OpenStruct.new(subdomains:  [ 'matrix' ])

    matcher = SubdomainMatcher.new(subdomain: 'matrix')

    expect(matcher.matches?(request)).to be_truthy
  end
end
end
end
