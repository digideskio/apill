require 'apill/matchers/generic'

module  Apill
module  Matchers
class   AcceptHeader
  include Generic

  def matches?(request)
    super

    accept_header.valid?
  end
end
end
end
