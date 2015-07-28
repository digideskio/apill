require 'apill/parameters/filter'

module Apill
module Resource
module Processors
class  Filtering
  attr_accessor :resource,
                :parameters

  def initialize(resource, parameters = {})
    self.resource   = resource
    self.parameters = Parameters::Filter.new(parameters['filter'] || {})
  end

  def self.processed(*attrs)
    new(*attrs).processed
  end

  def self.meta(*attrs)
    {}
  end

  def processed
    parameters.each_with_object(resource) do |name, value, filtered_resource|
      filter_method     = filter_method_for(name)
      filtered_resource = if !filter_method
                            resource
                          elsif filter_method.arity == 0
                            resource.public_send(filter_method.name)
                          else
                            resource.public_send(filter_method.name, value)
                          end
    end
  end

  private

  def filter_method_for(filter_item)
    filter_method_name = filter_method_name_for(filter_item)

    resource_class.method(filter_method_name) if filter_method_name
  end

  def filter_method_name_for(filter_item)
    if resource_class.respond_to? "for_#{filter_item}"
      "for_#{filter_item}"
    elsif resource_class.respond_to? filter_item
      filter_item
    end
  end

  def resource_class
    @resource_class ||= if resource.respond_to? :klass
                          resource.klass
                        else
                          resource
                        end
  end
end
end
end
end
