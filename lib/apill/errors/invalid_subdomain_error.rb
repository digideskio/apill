require 'human_error'

module  Apill
module  Errors
class   InvalidSubdomainError < HumanError::Errors::RequestError
  attr_accessor :http_host

  def http_status
    404
  end

  def developer_message
    'The resource you attempted to access is either not authorized for the ' \
    'authenticated user or does not exist.'
  end

  def developer_details
    { http_host: http_host }
  end

  def friendly_message
    'Sorry! The resource you tried to access does not exist.'
  end
end
end
end
