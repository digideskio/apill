module  Apill
module  Mixins
module  Pageable
  module ClassMethods
    def paginate(model)
      define_method(:paginated_model_name) do
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
      page_number    = params[:page]
      items_per_page = params[:per_page]

      resource = if defined? super
                   super
                 else
                   send(paginated_model_name)
                 end

      @paginated_resource = resource.
                              page(page_number).
                              per(items_per_page)
    end
  end

  def filter_data
    filter_data = defined?(super) ? super : {}

    filter_data.merge(pagination_data)
  end

  def pagination_data
    {
      'total-pages' =>   @paginated_resource.total_pages,
      'current-page' =>  @paginated_resource.current_page,
      'previous-page' => @paginated_resource.prev_page,
      'next-page' =>     @paginated_resource.next_page,
    }
  end
end
end
end
