require 'apill/configuration'
require 'apill/parameters'
require 'apill/matchers/subdomain'
require 'apill/matchers/accept_header'
require 'apill/requests/base'
require 'apill/responses/invalid_api_request'
require 'apill/responses/invalid_subdomain'
require 'apill/responses/invalid_token'

module  Apill
module  Middleware
class   ApiRequest
  JSON_API_MIME_TYPE_PATTERN = %r{application/vnd\.api\+json(?=\z|;)}

  def initialize(app)
    @app = app
  end

  # rubocop:disable Metrics/LineLength, Metrics/AbcSize
  def call(env)
    env['HTTP_X_APPLICATION_NAME'] = Apill.configuration.application_name

    request               = Requests::Base.resolve(env)
    subdomain_matcher     = Matchers::Subdomain.new
    accept_header_matcher = Matchers::AcceptHeader.new
    token                 = request.authorization_token

    return Responses::InvalidSubdomain.call(env)      unless subdomain_matcher.matches?(request)
    return Responses::InvalidApiRequest.call(env)     unless !subdomain_matcher.matches_api_subdomain?(request) ||
                                                             accept_header_matcher.matches?(request)
    return Responses::InvalidToken.call(env,
                                        application_name: request.application_name) \
           unless token.valid?

    env['X_DECRYPTED_JSON_WEB_TOKEN'] = token.to_h
    env['QUERY_STRING']               = Parameters.process(env['QUERY_STRING'])
    env['CONTENT_TYPE']               = env['CONTENT_TYPE'].
                                        to_s.
                                        gsub! JSON_API_MIME_TYPE_PATTERN,
                                              'application/json'

    @app.call(env)
  end
  # rubocop:enable Metrics/LineLength, Metrics/AbcSize
end
end
end
