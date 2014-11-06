require 'apill/matchers/generic_matcher'

module  Apill
module  Matchers
class   AcceptHeaderMatcher
  include Apill::Matchers::GenericMatcher

  def matches?(request)
    super

    accept_header.valid?
  end
end
end
end
