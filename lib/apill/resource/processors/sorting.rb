require 'apill/parameters/sort'

module  Apill
module  Resource
module  Processors
class   Sorting
  attr_accessor :resource,
                :parameters

  def initialize(resource, parameters = {})
    self.resource   = resource
    self.parameters = Parameters::Sort.new(parameters['sort'])
  end

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
    {
      'sort' => parameters.to_h,
    }
  end
end
end
end
end
