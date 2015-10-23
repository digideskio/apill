require 'apill/tokens/invalid'

module  Apill
module  Tokens
module  Base64s
class   Invalid < Tokens::Invalid
  def to_h
    [{}, {}]
  end
end
end
end
end
