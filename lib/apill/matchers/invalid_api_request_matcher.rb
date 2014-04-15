require 'apill/matchers/accept_header_matcher'

module  Apill
module  Matchers
class   InvalidApiRequestMatcher < AcceptHeaderMatcher
  def matches?(request)
    !super
  end
end
end
end
