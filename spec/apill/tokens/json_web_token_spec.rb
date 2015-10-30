require 'spec_helper'
require 'apill/tokens/json_web_token'

module    Apill
module    Tokens
describe  JsonWebToken do
  it 'can convert an empty encrypted token' do
    token = JsonWebToken.from_jwe(nil,
                                  private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Null
  end

  it 'can convert an invalid encrypted token' do
    token = JsonWebToken.from_jwe(invalid_jwe_token,
                                  private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can verify an expired encrypted token' do
    expired_jwe = valid_jwe_token('exp' => 1.day.ago.to_i,
                                  'baz' => 'bar')
    token       = JsonWebToken.from_jwe(expired_jwe,
                                        private_key: test_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can convert an invalidly signed encrypted token' do
    other_private_key = OpenSSL::PKey::RSA.new(2048)
    token             = JsonWebToken.from_jwe(valid_jwe_token,
                                              private_key: other_private_key)

    expect(token).to be_a JsonWebTokens::Invalid
  end

  it 'can convert a valid encrypted token' do
    token = JsonWebToken.from_jwe(valid_jwe_token,
                                  private_key: test_private_key)

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

  it 'can transform into a JWT' do
    token = JsonWebToken.new(data:        { 'foo' => 'bar' },
                             private_key: test_private_key)

    jwt   = token.to_jwt
    jwt_s = token.to_jwt_s

    expect(jwt.to_h).to eql({'foo' => 'bar'})
    expect(jwt_s).to    eql('eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJmb28iOiJiYXIifQ.')
  end

  it 'can transform into a JWS and back' do
    token = JsonWebToken.new(data:        { 'foo' => 'bar' },
                             private_key: test_private_key)

    jws   = token.to_jws
    jws_s = token.to_jws_s

    expect(jws.to_h).to eql({'foo' => 'bar'})
    expect(jws_s).to    eql('eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJmb28iOiJiYXIifQ.DhPBu9Bfha08hSoy1a8Ps5YGxv2_KJCoNALH8dzd8b_VgKCPRQlIaHZwQfS5N1yfZczc2EqXIhPma4I2i-L92oDxyugZYfhMH6XUXSgB6F7SU5WtiglQ8gfgxC_u_K5htD_6zpRaHi6UTNbG8NF3RFBYK9za4GFPPWQawRQpdH2CxjyZP6pilmkynLuKx0OeQbJf1yzdgn1cDt60M8uoZZTzPgoU598ilDjYEETwyGyCi79S3A3ix8oDaJLhM8stPOHLUeglKrkwxOFglzVs7bULjzxZlygZujsHfWu16cjp_P3b4TIH_hiH0-Cjin-EVt4va2TnfGJ8HDxHxzWn7g')

    converted_token = JsonWebToken.from_jws(jws_s,
                                            private_key: test_private_key)

    expect(converted_token.to_h).to eql [
      {'foo' => 'bar'},
      {"typ"=>"JWT", "alg"=>"RS256"}
    ]
  end

  it 'can transform into a JWE and back' do
    token = JsonWebToken.new(data:        { 'foo' => 'bar' },
                             private_key: test_private_key)

    jwe   = token.to_jwe
    jwe_s = token.to_jwe_s

    expect(jwe.plain_text).to eql('eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJmb28iOiJiYXIifQ.DhPBu9Bfha08hSoy1a8Ps5YGxv2_KJCoNALH8dzd8b_VgKCPRQlIaHZwQfS5N1yfZczc2EqXIhPma4I2i-L92oDxyugZYfhMH6XUXSgB6F7SU5WtiglQ8gfgxC_u_K5htD_6zpRaHi6UTNbG8NF3RFBYK9za4GFPPWQawRQpdH2CxjyZP6pilmkynLuKx0OeQbJf1yzdgn1cDt60M8uoZZTzPgoU598ilDjYEETwyGyCi79S3A3ix8oDaJLhM8stPOHLUeglKrkwxOFglzVs7bULjzxZlygZujsHfWu16cjp_P3b4TIH_hiH0-Cjin-EVt4va2TnfGJ8HDxHxzWn7g')

    converted_token = JsonWebToken.from_jwe(jwe_s,
                                            private_key: test_private_key)

    expect(converted_token.to_h).to eql [
      {'foo' => 'bar'},
      {"typ"=>"JWT", "alg"=>"RS256"}
    ]
  end
end
end
end
