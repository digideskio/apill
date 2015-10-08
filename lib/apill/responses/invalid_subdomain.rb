require 'apill/errors/invalid_subdomain'

module  Apill
module  Responses
class   InvalidSubdomain
  def self.call(env)
    error = Apill::Errors::InvalidSubdomain.new(http_host: env['HTTP_HOST'])

    [
      error.http_status,  # HTTP Status Code
      {},                 # Response Headers
      [error.to_json],  # Message
    ]
  end
end
end
end
