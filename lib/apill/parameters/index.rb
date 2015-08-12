module  Apill
class   Parameters
class   Index
  DEFAULT_QUERY = '*'

  attr_accessor :raw_parameters

  def initialize(raw_parameters)
    self.raw_parameters = raw_parameters || {}
  end

  def present?
    query
  end

  def query
    raw_parameters['query'] || raw_parameters['q']
  end
end
end
end
