module  Apill
module  Mixins
module  Sortable
  module ClassMethods
    def sort(model)
      define_method(:sorted_model_name) do
        model
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end

  private

  def filtered_resource
    @filtered_resource ||= begin
      resource = if defined? super
                   super
                 else
                   send(sorted_model_name)
                 end

      resource.
        order(sorting_arguments)
    end
  end

  def sorting_arguments
    sorting_data.values.join(' ')
  end

  def filter_data
    filter_data = defined?(super) ? super : {}

    filter_data.merge(sorting_data)
  end

  def sorting_data
    {
      sort:      params.fetch(:sort,      'created_at'),
      direction: params.fetch(:direction, 'DESC'),
    }
  end
end
end
end
