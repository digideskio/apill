require 'apill/configuration'
require 'apill/requests/base'
require 'apill/accept_header'

module  Apill
module  Requests
class   RailsRequest < Base
  private

  def raw_accept_header_from_header
    request.headers['Accept']
  end

  def raw_accept_header_from_params
    request.params['accept']
  end

  def raw_request_application_name
    request.headers['X-Application-Name']
  end
end
end
end
