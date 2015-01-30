module Apill
module Mixins
module Queryable
  module ClassMethods
    def query(model)
      define_method(:queryed_model_name) do
        model
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  private

  def query_params
    @query_params ||= params.fetch(:query_params, {})
  end

  def sanitized_query_params
    query_attrs = respond_to?(:queryable_attributes) ? queryable_attributes : {}

    query_params.
    slice(*query_attrs)
  end

  def query_method_name_for(query_item, resource)
    if resource.respond_to? "for_#{query_item}"
      "for_#{query_item}"
    elsif resource.respond_to? query_item
      query_item
    end
  end

  def filtered_resource
    @filtered_resource ||= begin
      resource = if defined? super
                   super
                 else
                   send(queryed_model_name)
                 end

      sanitized_query_params.reduce(resource) do |query_resource, query_param|
        key, value = query_param

        query_resource.public_send(query_method_name_for(key, query_resource), value)
      end
    end
  end
end
end
end
