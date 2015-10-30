module  Apill
module  Authorizer
class   Query
  attr_accessor :token,
                :user,
                :resource

  def initialize(token:, user:, resource:, **other)
    self.token    = token
    self.user     = user
    self.resource = resource

    other.each do |name, value|
      self.public_send("#{name}=", value)
    end
  end
end
end
end
