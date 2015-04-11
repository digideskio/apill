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
    @query_params ||= params[:query_params] || params || {}
  end

  def sanitized_query_params
    query_attrs = if respond_to?(:queryable_attributes, true)
                    queryable_attributes
                  else
                    []
                  end

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

  # rubocop:disable Metrics/PerceivedComplexity
  def filtered_resource
    @filtered_resource ||= begin
      resource       = if defined? super
                         super
                       else
                         send(queryed_model_name)
                       end
      resource       = if resource.respond_to? :records
                         resource.records
                       else
                         resource
                       end
      resource_class = if resource.respond_to? :klass
                         resource.klass.name.constantize
                       else
                         resource
                       end

      sanitized_query_params.reduce(resource) do |query_resource, query_param|
        key, value        = query_param
        query_method_name = query_method_name_for(key, resource_class).to_sym

        if resource_class.method(query_method_name).arity == 0
          query_resource.public_send(query_method_name)
        else
          query_resource.public_send(query_method_name, value)
        end
      end
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def filter_data
    filter_data = defined?(super) ? super : {}

    filter_data.merge(querying_data)
  end

  def querying_data
    {}
  end
end
end
end
