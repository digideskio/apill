require 'apill/configuration'
require 'apill/requests/base'
require 'apill/accept_header'

module  Apill
module  Requests
class   RackRequest < Base
  ACCEPT_PARAM_PATTERN = /(?:\A|&)accept=(.+?)(?=\z|&)/

  attr_accessor :request

  def initialize(request)
    self.request = request
  end

  def accept_header_from_header
    AcceptHeader.new(application: application_name,
                     header:      request['HTTP_ACCEPT'] || '')
  end

  def accept_header_from_params
    AcceptHeader.new(application: application_name,
                     header:      raw_accept_header_from_params || '')
  end

  def application_name
    request['HTTP_X_APPLICATION_NAME'] || Apill.configuration.application_name
  end

  private

  def raw_accept_header_from_params
    URI.unescape(request['QUERY_STRING'][ACCEPT_PARAM_PATTERN, 1] || '')
  end
end
end
end
