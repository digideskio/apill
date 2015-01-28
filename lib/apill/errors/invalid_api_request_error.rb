require 'human_error'

module  Apill
module  Errors
class   InvalidApiRequestError < HumanError::Errors::RequestError
  attr_accessor :accept_header

  def http_status
    400
  end

  def developer_message
    'The accept header that you passed in the request cannot be parsed, ' \
    'please refer to the documentation to verify.'
  end

  def developer_details
    { accept_header: accept_header }
  end

  def friendly_message
    "Sorry! We couldn't understand what you were trying to ask us to do."
  end
end
end
end
