require 'human_error'

module  Apill
module  Errors
class   InvalidApiRequestError < RuntimeError
  include HumanError::Error

  attr_accessor :accept_header

  def http_status
    400
  end

  def title
    'Invalid API Request'
  end

  def detail
    'The accept header that you passed in the request cannot be parsed, ' \
    'please refer to the documentation to verify.'
  end

  def source
    { accept_header: accept_header }
  end
end
end
end
