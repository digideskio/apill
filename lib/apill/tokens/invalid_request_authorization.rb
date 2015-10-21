require 'singleton'

module  Apill
module  Tokens
class   InvalidRequestAuthorization
  include Singleton

  def valid?
    false
  end

  def blank?
    false
  end

  def to_h
    [{}, {}]
  end
end
end
end
