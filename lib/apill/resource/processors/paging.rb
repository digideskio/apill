require 'apill/parameters/page'

module  Apill
module  Resource
module  Processors
class   Paging
  attr_accessor :resource,
                :parameters

  def initialize(resource, parameters = {})
    self.resource   = resource
    self.parameters = Parameters::Page.new(parameters['page'] || {})
  end

  def self.processed(*attrs)
    new(*attrs).processed
  end

  def self.meta(*attrs)
    new(*attrs).meta
  end

  def processed
    return resource unless parameters.present?

    resource.page(parameters.page_number).
             per(parameters.per_page)
  end

  def meta
    return {} unless parameters.present?

    {
      'total-pages'   => processed.total_pages,
      'current-page'  => processed.current_page,
      'previous-page' => processed.prev_page,
      'next-page'     => processed.next_page,
    }
  end
end
end
end
end
