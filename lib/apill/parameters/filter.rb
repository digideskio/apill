module  Apill
class   Parameters
class   Filter
  NUMERICAL_RANGE = /\A([\d\.]+?)\.\.\.?([\d\.]+?)\z/

  attr_accessor :raw_parameters

  def initialize(raw_parameters)
    self.raw_parameters = raw_parameters || {}
  end

  def present?
    compacted_parameters.any?
  end

  def each_with_object(memoized)
    compacted_parameters.each do |name, value|
      memoized = yield name, format_value(value), memoized
    end

    memoized
  end

  private

  def compacted_parameters
    @compacted_parameters ||= raw_parameters.reject do |name, value|
                                name == 'query' ||
                                value == '' ||
                                value.nil?
    end
  end

  # rubocop:disable Lint/AssignmentInCondition
  def format_value(value)
    return value unless value.is_a?(String)

    if range_points = value.match(NUMERICAL_RANGE)
      exclusive      = value.include? '...'
      starting_point = range_points[1].to_f
      ending_point   = range_points[2].to_f

      Range.new(starting_point, ending_point, exclusive)
    else
      value
    end
  end
  # rubocop:enable Lint/AssignmentInCondition
end
end
end
