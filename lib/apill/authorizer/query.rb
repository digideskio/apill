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

  def able_to_index?
    true
  end

  def able_to_show?
    false
  end

  def able_to_create?
    false
  end

  def able_to_update?
    false
  end

  def able_to_destroy?
    false
  end
end
end
end
