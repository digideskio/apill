require 'apill/configuration'
require 'apill/requests/base'
require 'apill/accept_header'
require 'apill/tokens/json_web_token'
require 'apill/tokens/base64'

module  Apill
module  Requests
class   Rails < Base
  def authorization_token_from_params
    case
    when request.params.key?(JSON_WEB_TOKEN_PARAM_NAME)
      Tokens::JsonWebToken.convert(
        token_private_key: token_private_key,
        raw_token:         request.params[JSON_WEB_TOKEN_PARAM_NAME] || '')
    when request.params.key?(BASE64_TOKEN_PARAM_NAME)
      Tokens::Base64.convert(raw_token: request.params[BASE64_TOKEN_PARAM_NAME] || '')
    else
      Tokens::Null.instance
    end
  end

  private

  def raw_accept_header_from_header
    request.headers['Accept']
  end

  def raw_accept_header_from_params
    request.params['accept']
  end

  def raw_authorization_header
    request.headers['HTTP_AUTHORIZATION'] || ''
  end

  def raw_request_application_name
    request.headers['X-Application-Name']
  end
end
end
end
