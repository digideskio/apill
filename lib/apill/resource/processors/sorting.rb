require 'apill/parameters/sort'

module  Apill
module  Resource
module  Processors
class   Sorting
  attr_accessor :resource,
                :parameters

  # rubocop:disable Style/OptionHash
  def initialize(resource, parameters = {})
    self.resource   = resource
    self.parameters = Parameters::Sort.new(parameters['sort'])
  end
  # rubocop:enable Style/OptionHash

  def self.processed(*attrs)
    new(*attrs).processed
  end

  def self.meta(*attrs)
    new(*attrs).meta
  end

  def processed
    return resource unless parameters.present?

    resource.order(parameters.to_h)
  end

  def meta
    return {} unless parameters.present?

    {
      'sort' => parameters.to_h,
    }
  end
end
end
end
end
