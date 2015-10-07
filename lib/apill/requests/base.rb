module  Apill
module  Requests
class   Base
  attr_accessor :request

  def initialize(request:)
    self.request = request
  end

  def accept_header
    if accept_header_from_header.valid? ||
       accept_header_from_params.invalid?

      accept_header_from_header
    else
      accept_header_from_params
    end
  end

  def application_name
    raw_request_application_name || Apill.configuration.application_name
  end

  def self.resolve(original_request)
    if original_request.respond_to? :headers
      rails_request_class.new(request: original_request)
    else
      rack_request_class.new(request: original_request)
    end
  end

  def self.rails_request_class
    require 'apill/requests/rails_request'

    Object.const_get('Apill::Requests::RailsRequest')
  end

  def self.rack_request_class
    require 'apill/requests/rack_request'

    Object.const_get('Apill::Requests::RackRequest')
  end

  private

  def accept_header_from_header
    AcceptHeader.new(application: application_name,
                     header:      raw_accept_header_from_header || '')
  end

  def accept_header_from_params
    AcceptHeader.new(application: application_name,
                     header:      raw_accept_header_from_params || '')
  end
end
end
end
