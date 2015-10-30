require 'jwt'
require 'json/jwt'
require 'apill/tokens/json_web_tokens/invalid'
require 'apill/tokens/json_web_tokens/null'

module  Apill
module  Tokens
class   JsonWebToken
  TRANSFORMATION_EXCEPTIONS = [
    JSON::JWT::Exception,
    JSON::JWT::InvalidFormat,
    JSON::JWT::VerificationFailed,
    JSON::JWT::UnexpectedAlgorithm,
    JWT::DecodeError,
    JWT::VerificationError,
    JWT::ExpiredSignature,
    JWT::IncorrectAlgorithm,
    JWT::ImmatureSignature,
    JWT::InvalidIssuerError,
    JWT::InvalidIatError,
    JWT::InvalidAudError,
    JWT::InvalidSubError,
    JWT::InvalidJtiError,
    OpenSSL::PKey::RSAError,
  ].freeze

  attr_accessor :data,
                :private_key

  def initialize(data:,
                 private_key: Apill.configuration.token_private_key)

    self.data        = data
    self.private_key = private_key
  end

  def valid?
    true
  end

  def blank?
    false
  end

  def to_h
    data
  end

  def to_jwt
    @jwt ||= JSON::JWT.new(data)
  end

  def to_jwt_s
    @jwt_s ||= to_jwt.to_s
  end

  def to_jws
    @jws ||= to_jwt.sign(private_key,    'RS256')
  end

  def to_jws_s
    @jws_s ||= to_jws.to_s
  end

  def to_jwe
    @jwe ||= to_jws.encrypt(private_key, 'RSA-OAEP', 'A256GCM')
  end

  def to_jwe_s
    @jwe_s ||= to_jwe.to_s
  end

  def self.from_jwe(encrypted_token,
                    private_key: Apill.configuration.token_private_key)

    return JsonWebTokens::Null.instance if encrypted_token.to_s == ''

    decrypted_token = JSON::JWT.
                        decode(encrypted_token, private_key).
                        plain_text

    from_jws(decrypted_token, private_key: private_key)
  rescue *TRANSFORMATION_EXCEPTIONS
    JsonWebTokens::Invalid.instance
  end

  def self.from_jws(signed_token,
                    private_key: Apill.configuration.token_private_key)

    return JsonWebTokens::Null.instance if signed_token.to_s == ''

    data = JWT.decode(
                       signed_token,
                       private_key,
                       true,
                       algorithm:         'RS256',
                       verify_expiration: true,
                       verify_not_before: true,
                       verify_iat:        true,
                       leeway:            5,
    )

    new(data:        data,
        private_key: private_key)
  rescue *TRANSFORMATION_EXCEPTIONS
    JsonWebTokens::Invalid.instance
  end
end
end
end
