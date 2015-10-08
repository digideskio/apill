require 'human_error'

module  Apill
module  Errors
class   InvalidToken < RuntimeError
  include HumanError::Error

  def http_status
    401
  end

  def title
    'Invalid or Unauthorized Token'
  end

  def detail
    'Either the token you passed is invalid or is not allowed to perform this action.'
  end
end
end
end
