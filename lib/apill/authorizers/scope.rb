module  Apill
module  Authorizers
class   Scope
  attr_accessor :token,
                :user,
                :scoped_user_id,
                :params,
                :scope_root

  # rubocop:disable Metrics/ParameterLists
  def initialize(token:, user:, params:, scoped_user_id:, scope_root:, **other)
    self.token          = token
    self.user           = user
    self.params         = params
    self.scoped_user_id = scoped_user_id
    self.scope_root     = scope_root

    other.each do |name, value|
      public_send("#{name}=", value)
    end
  end
  # rubocop:enable Metrics/ParameterLists

  def call
    scope_root.none
  end
end
end
end
