require 'apill/configuration'
require 'apill/parameters'
require 'apill/matchers/subdomain_matcher'
require 'apill/matchers/accept_header_matcher'
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

    subdomain_matcher = Matchers::SubdomainMatcher.new(request: env)

    if subdomain_matcher.matches?
      if !subdomain_matcher.matches_api_subdomain? ||
          Matchers::AcceptHeaderMatcher.new.matches?(env)

        env['QUERY_STRING'] = Parameters.process(env['QUERY_STRING'])

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
