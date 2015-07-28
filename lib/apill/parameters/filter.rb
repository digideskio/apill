module  Apill
class   Parameters
class   Filter
  attr_accessor :raw_parameters

  def initialize(raw_parameters)
    self.raw_parameters = raw_parameters
  end

  def each_with_object(memoized)
    raw_parameters.each do |raw_parameter|
      next if raw_parameter[0] == 'query' ||
              raw_parameter[1].nil?       ||
              raw_parameter[1] == ''

      memoized = yield raw_parameter[0], raw_parameter[1], memoized
    end

    memoized
  end
end
end
end
