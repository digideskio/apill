require 'spec_helper'
require 'apill/requests/base'
require 'apill/matchers/subdomain'
require 'apill/configuration'

module    Apill
module    Matchers
describe  Subdomain do
  before(:each) do
    Apill.configuration.allowed_subdomains     = %w{api}
    Apill.configuration.allowed_api_subdomains = %w{api}
  end

  it 'matches if the subdomain is API' do
    env     = { 'HTTP_HOST' => 'api.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(request: request)

    expect(matcher.matches?).to be_a TrueClass
  end

  it 'matches if the first subdomain is API' do
    env     = { 'HTTP_HOST' => 'api.matrix.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(request: request)

    expect(matcher.matches?).to be_a TrueClass
  end

  it 'does not match if the first subdomain is not API' do
    env     = { 'HTTP_HOST' => 'matrix.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(request: request)

    expect(matcher.matches?).to be_a FalseClass
  end

  it 'allows the matched subdomain to be specified' do
    env     = { 'HTTP_HOST' => 'matrix.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(allowed_subdomains: 'matrix',
                            request:            request)

    expect(matcher.matches?).to be_a TrueClass
  end

  it 'allows more than one subdomain to be matched' do
    env     = { 'HTTP_HOST' => 'matrix.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(allowed_subdomains: %w{api matrix},
                            request:            request)

    expect(matcher.matches?).to be_a TrueClass

    env     = { 'HTTP_HOST' => 'api.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(allowed_subdomains: %w{api matrix},
                            request:            request)

    expect(matcher.matches?).to be_a TrueClass
  end

  it 'can match only the api subdomain' do
    env     = { 'HTTP_HOST' => 'matrix.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(allowed_api_subdomains: %w{matrix},
                            request:                request)

    expect(matcher.matches_api_subdomain?).to be_a TrueClass
  end

  it 'matches "api" as an api subdomain by default' do
    env     = { 'HTTP_HOST' => 'api.example.com' }
    request = Requests::Base.resolve(env)
    matcher = Subdomain.new(request: request)

    expect(matcher.matches_api_subdomain?).to be_a TrueClass
  end
end
end
end
