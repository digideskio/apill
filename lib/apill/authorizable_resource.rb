require 'apill/resource/naming'
require 'apill/resource/model'

module  Apill
module  AuthorizableResource
  RESOURCE_COLLECTION_ACTIONS = %w{index}.freeze

  module ClassMethods
    def authorizer_prefix
      name[CONTROLLER_RESOURCE_NAME_PATTERN, 2]
    end

    def authorizer_class
      "#{authorizer_prefix}Authorizers::#{resource_class_name}".constantize
    end

    def authorizer_scope_class
      "#{authorizer_prefix}Authorizers::#{resource_class_name}::Scope".constantize
    end

    def authorizer_params_class
      "#{authorizer_prefix}Authorizers::#{resource_class_name}::Parameters".constantize
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

  def authorizer_params_class
    self.class.authorizer_params_class
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
    self.
    class.
    authorizer_params_class.
    new(token:  token,
        user:   authorized_user,
        params: params).
    call
  end

  def authorization_query
    "able_to_#{action_name}?"
  end

  def api_resource
    @resource ||= Resource::Model.new(
                    resource:   public_send(self.class.plural_resource_name),
                    parameters: api_resource_params)
  end

  def api_resource_params
    params.permit(:sort,
                  page:   %i{
                    number
                    size
                    offset
                    limit
                    cursor
                  },
                  filter: api_filterable_parameters)
  end

  def api_filterable_parameters
    @api_filterable_parameters ||= begin
      filter_params     = params.fetch(:filter, {})
      scalar_params     = [:query]
      array_params      = {}

      api_filterable_attributes.each do |api_filterable_attribute|
        if filter_params[api_filterable_attribute].class == Array
          array_params[api_filterable_attribute] = []
        else
          scalar_params << api_filterable_attribute
        end
      end

      scalar_params << array_params
    end
  end

  def api_filterable_attributes
    []
  end
end
end
