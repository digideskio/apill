require 'jwt'
require 'json/jwt'
require 'apill/tokens/json_web_tokens/invalid'
require 'apill/tokens/json_web_tokens/null'

module  Apill
module  Tokens
class   JsonWebToken
  attr_accessor :data

  def initialize(data:)
    self.data = data
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

  def self.from_jwe(encrypted_token, token_private_key: Apill.configuration.token_private_key)
    return JsonWebTokens::Null.instance if encrypted_token.to_s == ''

    decrypted_token = JSON::JWT.decode(encrypted_token, token_private_key).plain_text
    decoded_token   = JWT.decode(decrypted_token,
                                 token_private_key,
                                 true,
                                 algorithm:         'RS256',
                                 verify_expiration: true,
                                 verify_not_before: true,
                                 verify_iat:        true,
                                 leeway:            5,
                                )

    new(data: decoded_token)
  rescue JSON::JWT::Exception,
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
         OpenSSL::PKey::RSAError

    JsonWebTokens::Invalid.instance
  end
end
end
end
