require 'apill/resource/model'
require 'apill/resource/naming'

module  Apill
module  ProcessableResource
  def self.included(base)
    base.include Resource::Naming
  end

  private

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
