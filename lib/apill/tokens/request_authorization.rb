require 'jwt'
require 'json/jwt'
require 'apill/tokens/json_web_tokens/invalid'
require 'apill/tokens/null_request_authorization'

module  Apill
module  Tokens
class   RequestAuthorization
  attr_accessor :token

  def initialize(token:)
    self.token = token
  end

  def valid?
    true
  end

  def blank?
    false
  end

  def to_h
    token
  end

  def self.convert(raw_token:, token_private_key: Apill.configuration.token_private_key)
    return NullRequestAuthorization.instance if raw_token.to_s == ''

    decrypted_token = JSON::JWT.decode(raw_token, token_private_key).plain_text
    decoded_token   = JWT.decode(decrypted_token,
                                 token_private_key,
                                 true,
                                 algorithm:         'RS256',
                                 verify_expiration: true,
                                 verify_not_before: true,
                                 verify_iat:        true,
                                 leeway:            5,
                                )

    new(token: decoded_token)
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
