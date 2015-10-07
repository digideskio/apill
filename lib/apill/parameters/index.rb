module  Apill
class   Parameters
class   Index
  DEFAULT_QUERY = '*'.freeze

  attr_accessor :raw_parameters

  def initialize(raw_parameters)
    self.raw_parameters = raw_parameters || {}
  end

  def present?
    query
  end

  def query
    compacted_parameters['query'] || compacted_parameters['q']
  end

  private

  def compacted_parameters
    @compacted_parameters ||= raw_parameters.reject do |_name, value|
                                value == '' ||
                                value.nil?
    end
  end
end
end
end
