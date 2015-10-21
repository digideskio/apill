require 'singleton'

module  Apill
module  Tokens
class   NullRequestAuthorization
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
end
end
end
