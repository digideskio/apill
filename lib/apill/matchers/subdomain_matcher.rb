module  Apill
module  Matchers
class   SubdomainMatcher
  def initialize(allowed_subdomains:     Apill.configuration.allowed_subdomains,
                 request:)

    self.allowed_subdomains = Array(allowed_subdomains)
    self.request                = request
  end

  def matches?
    request_subdomain = request['HTTP_HOST'][/\A([a-z\-]+)/i, 1]

    allowed_subdomains.include? request_subdomain
  end

  protected

  attr_accessor :allowed_subdomains,
                :request
end
end
end
