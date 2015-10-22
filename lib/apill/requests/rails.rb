require 'apill/configuration'
require 'apill/requests/base'
require 'apill/accept_header'

module  Apill
module  Requests
class   Rails < Base
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

  def raw_authorization_token_from_params
    request.params[#{BASE64_TOKEN_PARAM_NAME}] || ''
  end

  def raw_request_application_name
    request.headers['X-Application-Name']
  end
end
end
end
