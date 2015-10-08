require 'apill/configuration'
require 'apill/parameters'
require 'apill/matchers/subdomain'
require 'apill/matchers/accept_header'
require 'apill/responses/invalid_api_request'
require 'apill/responses/invalid_subdomain'

module  Apill
module  Middleware
class   ApiRequest
  def initialize(app)
    @app = app
  end

  def call(env)
    env['HTTP_X_APPLICATION_NAME'] = Apill.configuration.application_name

    subdomain_matcher = Matchers::Subdomain.new(request: env)

    return Responses::InvalidSubdomain.call(env)  unless subdomain_matcher.matches?
    return Responses::InvalidApiRequest.call(env) unless !subdomain_matcher.matches_api_subdomain? ||
                                                                 Matchers::AcceptHeader.new.matches?(env)

        env['QUERY_STRING'] = Parameters.process(env['QUERY_STRING'])

        if env['CONTENT_TYPE'] == 'application/vnd.api+json'
          env['CONTENT_TYPE'] = 'application/json'
        end

        @app.call(env)
  end
end
end
end
