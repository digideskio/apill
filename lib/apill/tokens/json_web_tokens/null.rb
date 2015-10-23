require 'apill/tokens/null'

module  Apill
module  Tokens
module  JsonWebTokens
class   Null < Tokens::Null
  def to_h
    [{}, {}]
  end
end
end
end
end
