require 'spec_helper'
require 'apill/tokens/request_authorization'

module    Apill
module    Tokens
describe  RequestAuthorization do
  it 'can convert an empty token' do
    token = RequestAuthorization.convert(token_private_key: test_private_key,
                                         raw_token:         nil)

    expect(token).to be_a NullRequestAuthorization
  end

  it 'can convert an invalid token' do
    token = RequestAuthorization.convert(token_private_key: test_private_key,
                                         raw_token:         invalid_token)

    expect(token).to be_a InvalidRequestAuthorization
  end

  it 'can verify an expired token' do
    expired_jwe = valid_token('exp' => 1.day.ago.to_i,
                              'baz' => 'bar')
    token       = RequestAuthorization.convert(
                    token_private_key: test_private_key,
                    raw_token:         expired_jwe)

    expect(token).to be_a InvalidRequestAuthorization
  end

  it 'can convert an invalidly signed token' do
    other_private_key = OpenSSL::PKey::RSA.new(2048)
    token             = RequestAuthorization.convert(
                          token_private_key: other_private_key,
                          raw_token:         valid_token)

    expect(token).to be_a InvalidRequestAuthorization
  end

  it 'can convert a valid token' do
    token = RequestAuthorization.convert(token_private_key: test_private_key,
                                         raw_token:         valid_token)

    expect(token).to      be_a RequestAuthorization
    expect(token.to_h).to eql([{ 'bar' => 'baz' }, { 'typ' => 'JWT', 'alg' => 'RS256' }])
  end
end
end
end