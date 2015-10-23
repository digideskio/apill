require 'apill/configuration'
require 'apill/requests/base'
require 'apill/accept_header'
require 'apill/tokens/json_web_token'
require 'apill/tokens/base64'

module  Apill
module  Requests
class   Rack < Base
  ACCEPT_PARAM_PATTERN         = /(?:\A|&)accept=(.+?)(?=\z|&)/
  BASE64_TOKEN_PARAM_PATTERN   = /(?:\A|&)#{BASE64_TOKEN_PARAM_NAME}=(.*)(?=\z|&)/
  JSON_WEB_TOKEN_PARAM_PATTERN = /(?:\A|&)#{JSON_WEB_TOKEN_PARAM_NAME}=(.*)(?=\z|&)/

  def authorization_token_from_params
    case request['QUERY_STRING']
    when JSON_WEB_TOKEN_PARAM_PATTERN
      Tokens::JsonWebToken.convert(
        token_private_key: token_private_key,
        raw_token:         request['QUERY_STRING'][JSON_WEB_TOKEN_PARAM_PATTERN, 1] || '',
      )
    when BASE64_TOKEN_PARAM_PATTERN
      base64_token = request['QUERY_STRING'][BASE64_TOKEN_PARAM_PATTERN, 1]

      Tokens::Base64.convert(raw_token: base64_token)
    else
      Tokens::Null.instance
    end
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
