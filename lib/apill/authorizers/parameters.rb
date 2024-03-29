module  Apill
module  Authorizers
class   Parameters
  attr_accessor :token,
                :user,
                :params

  def initialize(token:, user:, params:, **other)
    self.token  = token
    self.user   = user
    self.params = params

    other.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def call
    params
  end
end
end
end
