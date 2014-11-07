require 'json'
require 'apill/configuration'
require 'apill/matchers/subdomain_matcher'
require 'apill/matchers/invalid_api_request_matcher'
require 'apill/responses/invalid_api_request_response'
require 'apill/responses/invalid_subdomain_response'

module  Apill
module  Middleware
class   ApiRequest
  def initialize(app)
    @app = app
  end

  def call(env)
    env['HTTP_X_APPLICATION_NAME'] = Apill.configuration.application_name

    if Matchers::SubdomainMatcher.new(allowed_subdomains: Apill.configuration.allowed_subdomains).
                                  matches?(env)

      if Matchers::AcceptHeaderMatcher.new.matches?(env)
        @app.call(env)
      else
        Responses::InvalidApiRequestResponse.call(env)
      end
    else
      Responses::InvalidSubdomainResponse.call(env)
    end
  end
end
end
end
