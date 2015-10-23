require 'singleton'

module  Apill
module  Tokens
class   Null
  include Singleton

  def valid?
    true
  end

  def blank?
    true
  end

  def to_h
    [{}, {}]
  end

  def to_s
    ''
  end
end
end
end
