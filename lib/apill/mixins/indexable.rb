module Apill
module Mixins
module Indexable
  module ClassMethods
    def index(model)
      define_method(:indexed_model_name) do
        model
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  private

  def index_params
    @index_params ||= params[:index_params] || params || {}
  end

  def filtered_resource
    @filtered_resource ||= begin
      resource = if defined? super
                   super
                 else
                   send(indexed_model_name)
                 end

      if index_params.key? 'q'
        resource.search(index_params['q'])
      else
        resource
      end
    end
  end

  def filter_data
    filter_data = defined?(super) ? super : {}

    filter_data.merge(indexing_data)
  end

  def indexing_data
    {}
  end
end
end
end
