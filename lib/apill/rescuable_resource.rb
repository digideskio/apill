require 'human_error'

module  Apill
module  RescuableResource
  module ClassMethods
    def rescue_resource(resource_name, from:, via:)
      lookup_library = via

      if from.include? 'persistence'
        rescue_from HumanError::Errors::ResourcePersistenceError do |e|
          error = lookup_library.fetch(
                  'ResourcePersistenceError',
                  resource_name: e.resource_name,
                  attributes:    e.attributes,
                  errors:        e.errors,
                  action:        action_name)

          render json:   error,
                 status: error.http_status
        end
      end

      if from.include? 'not_found'
        rescue_from HumanError::Errors::ResourceNotFoundError do |e|
          error = lookup_library.fetch(
                  'ResourceNotFoundError',
                  resource_name: e.resource_name,
                  resource_id:   e.resource_id,
                  action:        action_name)

          render json:   error,
                 status: error.http_status
        end
      end

      if from.include? 'association'
        rescue_from HumanError::Errors::AssociationError do |e|
          error = lookup_library.fetch(
                  'AssociationError',
                  resource_name:    e.resource_name,
                  association_name: e.association_name,
                  association_id:   e.association_id,
                  attributes:       e.attributes)

          render json:   error,
                 status: error.http_status
        end
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
end
