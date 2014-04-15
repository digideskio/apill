require 'apill/errors/invalid_api_request_error'

module  Apill
module  Responses
class   InvalidApiRequestResponse
  def self.call(env)
    error = Apill::Errors::InvalidApiRequestError.new

    [
      error.http_status,  # HTTP Status Code
      {},                 # Response Headers
      error.to_json,      # Message
    ]
  end
end
end
end
