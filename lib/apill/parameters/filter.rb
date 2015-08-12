module  Apill
class   Parameters
class   Filter
  attr_accessor :raw_parameters

  def initialize(raw_parameters)
    self.raw_parameters = raw_parameters
  end

  def each_with_object(memoized)
    compacted_parameters.each do |name, value|
      memoized = yield name, value, memoized
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
end
end
end
