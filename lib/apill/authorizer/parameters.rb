module  Apill
module  Authorizer
class   Parameters
  attr_accessor :token,
                :user,
                :params

  def initialize(token:, user:, params:, **other)
    self.token  = token
    self.user   = user
    self.params = params

    other.each do |name, value|
      self.public_send("#{name}=", value)
    end
  end
end
end
end
