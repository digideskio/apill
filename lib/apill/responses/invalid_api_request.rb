require 'apill/errors/invalid_api_request'

module  Apill
module  Responses
class   InvalidApiRequest
  def self.call(env)
    error = Apill::Errors::InvalidApiRequest.new(accept_header: env['HTTP_ACCEPT'])

    [
      error.http_status,  # HTTP Status Code
      {},                 # Response Headers
      [error.to_json],  # Message
    ]
  end
end
end
end
