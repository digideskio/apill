require 'base64'
require 'apill/tokens/base64s/null'
require 'apill/tokens/base64s/invalid'

module  Apill
module  Tokens
class   Base64
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
    [
      {
        'token' => token,
      },
      {
        'typ' => 'base64',
      },
    ]
  end

  def self.convert(raw_token:)
    return Base64s::Null.instance if raw_token.to_s == ''

    ::Base64.strict_decode64(raw_token)

    new(token: raw_token)
  rescue ArgumentError
    Base64s::Invalid.instance
  end
end
end
end
