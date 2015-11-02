require 'apill/resource/naming'
require 'apill/resource/model'

module  Apill
module  AuthorizableResource
  RESOURCE_COLLECTION_ACTIONS = %w{index}.freeze

  module ClassMethods
    def authorizer_prefix
      @authorizer_prefix ||= name[Resource::Naming::CONTROLLER_RESOURCE_NAME_PATTERN, 2]
    end

    def authorizer_class
      @authorizer_class ||= "#{authorizer_prefix}" \
                            'Authorizers::' \
                            "#{resource_class_name}".
                            constantize
    rescue NameError
      'Apill::Authorizers::Query'.constantize
    end

    def authorizer_scope_class
      @authorizer_scope_class ||= "#{authorizer_prefix}" \
                                  'Authorizers::' \
                                  "#{resource_class_name}" \
                                  '::Scope'.
                                  constantize
    rescue NameError
      'Apill::Authorizers::Scope'.constantize
    end

    def authorizer_resource_params_class
      @authorizer_resource_params_class ||= "#{authorizer_prefix}" \
                                            'Authorizers::' \
                                            "#{resource_class_name}" \
                                            '::ResourceParameters'.
                                            constantize
    rescue NameError
      'Apill::Authorizers::Parameters::Resource'.constantize
    end

    def authorizer_filtering_params_class
      @authorizer_filtering_params_class ||= "#{authorizer_prefix}" \
                                             'Authorizers::' \
                                             "#{resource_class_name}::" \
                                             'FilteringParameters'.
                                             constantize
    rescue NameError
      'Apill::Authorizers::Parameters::Filtering'.constantize
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

  def authorizer
    @authorizer ||= self.
                    class.
                    authorizer_class.
                    new(token:    token,
                        user:     authorized_user,
                        resource: authorized_resource)
  end

  def authorized_scope
    @authorized_scope ||= self.
                          class.
                          authorizer_scope_class.
                          new(token:          token,
                              user:           authorized_user,
                              scoped_user_id: scoped_user_id,
                              params:         authorized_params,
                              scope_root:     authorized_scope_root).
                          call
  end

  def authorized_params
    @authorized_params ||= authorizer_params_class.
                           new(token:  token,
                               user:   authorized_user,
                               params: params).
                           call
  end

  def authorized_resource
    return nil if RESOURCE_COLLECTION_ACTIONS.include?(action_name)

    @authorized_resource ||= public_send(self.class.singular_resource_name)
  end

  def authorized_collection
    return nil unless RESOURCE_COLLECTION_ACTIONS.include?(action_name)

    @authorized_collection ||= Resource::Model.
      new(resource:   public_send(self.class.plural_resource_name),
          parameters: authorized_params)
  end

  def authorizer_params_class
    @authorizer_params_class ||= \
      if RESOURCE_COLLECTION_ACTIONS.include?(action_name)
        self.class.authorizer_filtering_params_class
      else
        self.class.authorizer_resource_params_class
      end
  end

  def authorized_scope_root
    @authorized_scope_root ||= "#{self.class.authorizer_prefix}" \
                               "#{self.class.resource_class_name}".
                               constantize
  end

  def scoped_user_id
    @scoped_user_id ||= if requested_user_id.blank?
                          nil
                        else
                          requested_user_id
                        end
  end

  def requested_user_id
    @requested_user_id ||= params.
                           fetch(:filter, {}).
                           fetch(authorized_user_underscored_class_name,
                                 authorized_user.id)
  end

  def authorized_user
    current_user
  end

  def authorized_user_underscored_class_name
    @authorized_user_underscored_class_name ||= authorized_user.
                                                class.
                                                name[/([^:]+)\z/, 1].
                                                underscore.
                                                downcase
  end

  def authorization_query
    @authorization_query ||= "able_to_#{action_name}?"
  end
end
end
