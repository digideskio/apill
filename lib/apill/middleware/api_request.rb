require 'apill/configuration'
require 'apill/parameters'
require 'apill/matchers/subdomain_matcher'
require 'apill/matchers/accept_header_matcher'
require 'apill/responses/invalid_api_request_response'
require 'apill/responses/invalid_subdomain'

module  Apill
module  Middleware
class   ApiRequest
  def initialize(app)
    @app = app
  end

  def call(env)
    env['HTTP_X_APPLICATION_NAME'] = Apill.configuration.application_name

    subdomain_matcher = Matchers::SubdomainMatcher.new(request: env)

    return Responses::InvalidSubdomain.call(env)  unless subdomain_matcher.matches?
    return Responses::InvalidApiRequestResponse.call(env) unless !subdomain_matcher.matches_api_subdomain? ||
                                                                 Matchers::AcceptHeaderMatcher.new.matches?(env)

        env['QUERY_STRING'] = Parameters.process(env['QUERY_STRING'])

        if env['CONTENT_TYPE'] == 'application/vnd.api+json'
          env['CONTENT_TYPE'] = 'application/json'
        end

        @app.call(env)
  end
end
end
end
