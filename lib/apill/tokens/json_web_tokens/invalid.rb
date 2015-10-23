require 'apill/tokens/invalid'

module  Apill
module  Tokens
module  JsonWebTokens
class   Invalid < Tokens::Invalid
  def to_h
    [{}, {}]
  end
end
end
end
end
