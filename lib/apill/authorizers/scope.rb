module  Apill
module  Authorizers
class   Scope
  attr_accessor :token,
                :user,
                :requested_user_id,
                :scope_root

  def initialize(token:, user:, requested_user_id:, scope_root:, **other)
    self.token             = token
    self.user              = user
    self.requested_user_id = requested_user_id
    self.scope_root        = scope_root

    other.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def call
    scope_root.none
  end
end
end
end
