require 'human_error'

module  Apill
module  Errors
class   InvalidSubdomainError < RuntimeError
  include HumanError::Error

  attr_accessor :http_host

  def http_status
    404
  end

  def title
    'Invalid Subdomain'
  end

  def detail
    'The resource you attempted to access is either not authorized for the ' \
    'authenticated user or does not exist.'
  end

  def source
    { http_host: http_host }
  end
end
end
end
