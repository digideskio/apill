require 'singleton'

module  Apill
module  Tokens
class   Invalid
  include Singleton

  def valid?
    false
  end

  def blank?
    false
  end

  def to_h
    {}
  end

  def to_s
    ''
  end
end
end
end
