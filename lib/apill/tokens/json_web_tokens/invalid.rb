require 'singleton'

module  Apill
module  Tokens
module  JsonWebTokens
class   Invalid
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
end
