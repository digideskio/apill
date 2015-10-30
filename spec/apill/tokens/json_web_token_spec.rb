require 'spec_helper'
require 'apill/tokens/json_web_token'

module    Apill
module    Tokens
describe  JsonWebToken do
  it 'can convert an empty token' do
    token = JsonWebToken.from_jwe(encrypted_token:   nil,
                                  token_private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Null
  end

  it 'can convert an invalid token' do
    token = JsonWebToken.from_jwe(encrypted_token:   invalid_jwt_token,
                                  token_private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can verify an expired token' do
    expired_jwe = valid_jwt_token('exp' => 1.day.ago.to_i,
                                  'baz' => 'bar')
    token       = JsonWebToken.from_jwe(encrypted_token:   expired_jwe,
                                        token_private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can convert an invalidly signed token' do
    other_private_key = OpenSSL::PKey::RSA.new(2048)
    token             = JsonWebToken.from_jwe(encrypted_token:   valid_jwt_token,
                                              token_private_key: other_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can convert a valid token' do
    token = JsonWebToken.from_jwe(encrypted_token:   valid_jwt_token,
                                  token_private_key: test_private_key)

    expect(token).to      be_a JsonWebToken
    expect(token.to_h).to eql([{ 'bar' => 'baz' }, { 'typ' => 'JWT', 'alg' => 'RS256' }])
  end
end
end
end
