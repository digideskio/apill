module  Apill
module  Matchers
class   Subdomain
  def initialize(allowed_subdomains:     Apill.configuration.allowed_subdomains,
                 allowed_api_subdomains: Apill.configuration.allowed_api_subdomains)

    self.allowed_subdomains     = Array(allowed_subdomains)
    self.allowed_api_subdomains = Array(allowed_api_subdomains)
  end

  def matches?(request)
    self.request = request

    allowed_subdomains.include? request.subdomain
  end

  def matches_api_subdomain?(request)
    self.request = request

    allowed_api_subdomains.include? request.subdomain
  end

  protected

  attr_accessor :allowed_subdomains,
                :allowed_api_subdomains,
                :request
end
end
end
