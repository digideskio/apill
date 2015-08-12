module  Apill
class   Parameters
class   Page
  DEFAULT_STARTING_PAGE = 1
  DEFAULT_PAGE_SIZE     = 25

  attr_accessor :raw_parameters

  def initialize(raw_parameters)
    self.raw_parameters = raw_parameters || {}
  end

  def page_number
    raw_parameters['number'] || DEFAULT_STARTING_PAGE
  end

  def per_page
    raw_parameters['size'] || DEFAULT_PAGE_SIZE
  end
end
end
end
