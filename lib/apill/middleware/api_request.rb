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

  # rubocop:disable Metrics/LineLength
  def call(env)
    env['HTTP_X_APPLICATION_NAME'] = Apill.configuration.application_name

    request               = Requests::Base.resolve(env)
    subdomain_matcher     = Matchers::Subdomain.new(request: request)
    accept_header_matcher = Matchers::AcceptHeader.new(request: request)

    return Responses::InvalidSubdomain.call(env)  unless subdomain_matcher.matches?
    return Responses::InvalidApiRequest.call(env) unless !subdomain_matcher.matches_api_subdomain? ||
                                                         accept_header_matcher.matches?

    env['QUERY_STRING'] = Parameters.process(env['QUERY_STRING'])

    if env['CONTENT_TYPE'] == 'application/vnd.api+json'
      env['CONTENT_TYPE'] = 'application/json'
    end

    @app.call(env)
  end
  # rubocop:enable Metrics/LineLength
end
end
end
