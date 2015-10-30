require 'spec_helper'
require 'apill/tokens/json_web_token'

module    Apill
module    Tokens
describe  JsonWebToken do
  it 'can convert an empty token' do
    token = JsonWebToken.from_jwe(nil,
                                  token_private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Null
  end

  it 'can convert an invalid token' do
    token = JsonWebToken.from_jwe(invalid_jwe_token,
                                  token_private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can verify an expired token' do
    expired_jwe = valid_jwe_token('exp' => 1.day.ago.to_i,
                                  'baz' => 'bar')
    token       = JsonWebToken.from_jwe(expired_jwe,
                                        token_private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can convert an invalidly signed token' do
    other_private_key = OpenSSL::PKey::RSA.new(2048)
    token             = JsonWebToken.from_jwe(valid_jwe_token,
                                              token_private_key: other_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can convert a valid token' do
    token = JsonWebToken.from_jwe(valid_jwe_token,
                                  token_private_key: test_private_key)

    expect(token).to      be_a JsonWebToken
    expect(token.to_h).to eql([{ 'bar' => 'baz' }, { 'typ' => 'JWT', 'alg' => 'RS256' }])
  end

  it 'can convert an empty signed token' do
    token = JsonWebToken.from_jws(nil,
                                  private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Null
  end

  it 'can verify an expired signed token' do
    expired_jws = valid_jws_token('exp' => 1.day.ago.to_i,
                                  'baz' => 'bar')
    token       = JsonWebToken.from_jws(expired_jws,
                                        private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can convert an invalidly signed token' do
    other_private_key             = OpenSSL::PKey::RSA.new(2048)
    token_signed_with_another_key = JsonWebToken.from_jws(valid_jws_token,
                                                          private_key: other_private_key)
    invalid_token                 = JsonWebToken.from_jws(invalid_jws_token,
                                                          private_key: test_private_key)

    expect(token_signed_with_another_key).to be_a JsonWebTokens::Invalid
    expect(invalid_token).to                 be_a JsonWebTokens::Invalid
  end

  it 'can convert a valid signed token' do
    token = JsonWebToken.from_jws(valid_jws_token,
                                  private_key: test_private_key)

    expect(token).to      be_a JsonWebToken
    expect(token.to_h).to eql([{ 'bar' => 'baz' }, { 'typ' => 'JWT', 'alg' => 'RS256' }])
  end
end
end
end
