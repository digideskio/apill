require 'apill/errors/invalid_token'

module  Apill
module  Responses
class   InvalidToken
  def self.call(_env, application_name:)
    error = Apill::Errors::InvalidToken.new

    [
      error.http_status, # HTTP Status Code
      {                  # Response Headers
        'WWW-Authenticate' => %Q{Token realm="#{application_name}"},
      },
      [error.to_json],   # Message
    ]
  end
end
end
end
