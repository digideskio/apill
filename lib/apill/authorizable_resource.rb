require 'apill/resource/naming'
require 'apill/resource/model'

module  Apill
module  AuthorizableResource
  RESOURCE_COLLECTION_ACTIONS = %w{index}.freeze

  module ClassMethods
    def authorizer_prefix
      name[Resource::Naming::CONTROLLER_RESOURCE_NAME_PATTERN, 2]
    end

    def authorizer_class
      "#{authorizer_prefix}Authorizers::#{resource_class_name}".constantize
    rescue NameError
      "Apill::Authorizers::Query".constantize
    end

    def authorizer_scope_class
      "#{authorizer_prefix}Authorizers::#{resource_class_name}::Scope".constantize
    rescue NameError
      "Apill::Authorizers::Scope".constantize
    end

    def authorizer_resource_params_class
      "#{authorizer_prefix}Authorizers::#{resource_class_name}::ResourceParameters".
      constantize
    rescue NameError
      "Apill::Authorizers::Parameters::Resource".constantize
    end

    def authorizer_filtering_params_class
      "#{authorizer_prefix}Authorizers::#{resource_class_name}::FilteringParameters".
      constantize
    rescue NameError
      "Apill::Authorizers::Parameters::Filtering".constantize
    end
  end

  def self.included(base)
    base.include Resource::Naming
    base.extend  ClassMethods

    base.before_action :authorize
  end

  private

  def authorize
    HumanError.raise(
      'ForbiddenError',
      resource_name: self.class.singular_resource_name,
      resource_id:   [params[:id]],
      action:        action_name,
    ) unless authorizer.public_send(authorization_query)
  end

  def authorizer_class
    self.class.authorizer_class
  end

  def authorized_scope_root
    "#{self.class.authorizer_prefix}#{self.class.resource_class_name}".constantize
  end

  def authorizer_scope_class
    self.class.authorizer_scope_class
  end

  def authorizer_resource_params_class
    self.class.authorizer_resource_params_class
  end

  def authorizer_filtering_params_class
    self.class.authorizer_filtering_params_class
  end

  def authorized_user
    current_user
  end

  def authorized_user_underscored_class_name
    authorized_user.
    class.
    name[/([^:])\z/, 1].
    underscore.
    downcase
  end

  def authorized_user_field_name
    authorized_user_underscored_class_name + '_id'
  end

  def requested_user_id
    params.fetch(authorized_user_field_name, authorized_user.id)
  end

  def authorized_resource
    return nil if RESOURCE_COLLECTION_ACTIONS.include?(action_name)

    public_send(self.class.singular_resource_name)
  end

  def authorized_collection
    return nil unless RESOURCE_COLLECTION_ACTIONS.include?(action_name)

    @authorized_collection ||= Resource::Model.
      new(resource:   public_send(self.class.plural_resource_name),
          parameters: authorized_params)
  end

  def authorizer
    authorizer_class.
    new(token:    token,
        user:     authorized_user,
        resource: authorized_resource)
  end

  def authorized_scope
    self.
    class.
    authorizer_scope_class.
    new(token:             token,
        user:              authorized_user,
        requested_user_id: requested_user_id,
        scope_root:        authorized_scope_root).
    call
  end

  def authorized_params
    authorizer_params_class.
    new(token:  token,
        user:   authorized_user,
        params: params).
    call
  end

  def authorizer_params_class
    @authorizer_params_class ||= \
      if RESOURCE_COLLECTION_ACTIONS.include?(action_name)
        authorizer_filtering_params_class
      else
        authorizer_resource_params_class
      end
  end

  def authorization_query
    "able_to_#{action_name}?"
  end
end
end
