require 'apill/configuration'
require 'apill/requests/base'
require 'apill/accept_header'

module  Apill
module  Requests
class   Rack < Base
  ACCEPT_PARAM_PATTERN         = /(?:\A|&)accept=(.+?)(?=\z|&)/
  BASE64_TOKEN_PARAM_PATTERN   = /(?:\A|&)#{BASE64_TOKEN_PARAM_NAME}=(#{BASE64_PATTERN}+)(?=\z|&)/
  JSON_WEB_TOKEN_PARAM_PATTERN = /(?:\A|&)#{JSON_WEB_TOKEN_PARAM_NAME}=(#{JSON_WEB_TOKEN_PATTERN})(?=\z|&)/

  def authorization_token_from_params
      Tokens::JsonWebToken.convert(
        token_private_key: token_private_key,
        raw_token:         URI.unescape(
                             request['QUERY_STRING'][JSON_WEB_TOKEN_PARAM_PATTERN, 1] ||
                             ''
                           ),
      )
  end

  private

  def raw_accept_header_from_header
    request['HTTP_ACCEPT']
  end

  def raw_accept_header_from_params
    URI.unescape(request['QUERY_STRING'][ACCEPT_PARAM_PATTERN, 1] || '')
  end

  def raw_authorization_header
    request['HTTP_AUTHORIZATION'] || ''
  end

  def raw_request_application_name
    request['HTTP_X_APPLICATION_NAME']
  end
end
end
end
