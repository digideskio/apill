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
end
end
end
