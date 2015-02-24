module  Apill
module  Matchers
class   SubdomainMatcher
  def initialize(allowed_subdomains:     Apill.configuration.allowed_subdomains,
                 allowed_api_subdomains: Apill.configuration.allowed_api_subdomains,
                 request:)

    self.allowed_subdomains     = Array(allowed_subdomains)
    self.allowed_api_subdomains = Array(allowed_api_subdomains)
    self.request                = request
  end

  def matches?
    allowed_subdomains.include? request_subdomain
  end

  def matches_api_subdomain?
    allowed_api_subdomains.include? request_subdomain
  end

  protected

  attr_accessor :allowed_subdomains,
                :allowed_api_subdomains,
                :request

  private

  def request_subdomain
    @request_subdomain ||= request['HTTP_HOST'][/\A([a-z\-]+)/i, 1]
  end
end
end
end
