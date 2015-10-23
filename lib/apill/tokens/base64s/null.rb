require 'apill/tokens/null'

module  Apill
module  Tokens
module  Base64s
class   Null < Tokens::Null
  def to_h
    [{}, {}]
  end
end
end
end
end
