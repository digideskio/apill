require 'apill/errors/invalid_subdomain_error'

module  Apill
module  Responses
class   InvalidSubdomainResponse
  def self.call(env)
    error = Apill::Errors::InvalidSubdomainError.new(http_host: env['HTTP_HOST'])

    [
      error.http_status,  # HTTP Status Code
      {},                 # Response Headers
      [ error.to_json ],  # Message
    ]
  end
end
end
end
