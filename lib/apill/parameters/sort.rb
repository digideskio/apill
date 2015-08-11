module  Apill
class   Parameters
class   Sort
  DESCENDING_PREFIX = '-'

  attr_accessor :raw_parameters

  def initialize(raw_parameters)
    self.raw_parameters = raw_parameters ? raw_parameters.split(',') : ['-created_at']
  end

  def to_h
    @to_h ||= Hash[to_a]
  end

  def to_a
    @to_a ||= raw_parameters.map do |raw_parameter|
      if raw_parameter.start_with?(DESCENDING_PREFIX)
        [raw_parameter[1..-1], 'desc']
      else
        [raw_parameter, 'asc']
      end
    end
  end
end
end
end
