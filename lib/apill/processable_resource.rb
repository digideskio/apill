require 'apill/resource/model'

module  Apill
module  ProcessableResource
  module ClassMethods
    def plural_resource_name
      name[/(\w+)Controller\z/, 1].
      underscore.
      pluralize.
      downcase
    end

    def singular_resource_name
      name[/(\w+)Controller\z/, 1].
      underscore.
      singularize.
      downcase
    end
  end

  def self.included(base)
    base.extend  ClassMethods
  end

  def api_resource
    @resource ||= Resource::Model.new(
                    resource:   public_send(self.class.plural_resource_name),
                    parameters: api_resource_params)
  end

  def api_resource_params
    params.permit(:sort,
                  page:    %i{
                    number
                    size
                    offset
                    limit
                    cursor
                  },
                  filter:  api_filterable_parameters,
                  include: api_include_parameters)
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

  def api_include_parameters
    @api_include_parameters ||= begin
      include_params = params.fetch(:include, '').split(',')
      array_params   = []

      api_includeable_associations.each do |api_includeable_association|
        if include_params.include? api_includeable_association
          array_params << api_includeable_association
        end
      end
      array_params
    end
  end

  def api_includeable_associations
    []
  end

  def api_filterable_attributes
    []
  end
end
end
