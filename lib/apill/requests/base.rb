module  Apill
module  Requests
class   Base
  def self.resolve(original_request)
    if original_request.respond_to? :headers
      rails_request_class.new(original_request)
    else
      rack_request_class.new(original_request)
    end
  end

  def accept_header
    if accept_header_from_header.valid? ||
       accept_header_from_params.invalid?

      accept_header_from_header
    else
      accept_header_from_params
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
end
end
end
