module  Apill
module  Matchers
class   SubdomainMatcher
  def initialize(subdomain: 'api')
    self.subdomain = subdomain
  end

  def matches?(request)
    request.subdomains.first == subdomain
  end

  protected

  attr_accessor :subdomain
end
end
end
