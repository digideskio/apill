require 'apill/configuration'
require 'apill/requests/base'
require 'apill/accept_header'

module  Apill
module  Requests
class   RailsRequest < Base
  attr_accessor :request

  def initialize(request)
    self.request = request
  end

  def accept_header_from_header
    AcceptHeader.new(application: application_name,
                     header:      request.headers['Accept'] || '')
  end

  def accept_header_from_params
    AcceptHeader.new(application: application_name,
                     header:      request.params['accept'] || '')
  end

  def application_name
    request.headers['X-Application-Name'] || Apill.configuration.application_name
  end
end
end
end
