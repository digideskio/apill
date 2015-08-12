require 'apill/parameters/index'

module Apill
module Resource
module Processors
class  Indexing
  attr_accessor :resource,
                :parameters

  def initialize(resource, parameters = {})
    self.resource   = resource
    self.parameters = Parameters::Index.new(parameters['filter'] || {})
  end

  def self.processed(*attrs)
    new(*attrs).processed
  end

  def self.meta(*_attrs)
    {}
  end

  def processed
    return resource unless parameters.present? || force_query

    resource.for_query(parameters.query || Parameters::Index::DEFAULT_QUERY)
  end

  private

  def force_query
    resource.class.name.include? 'Index'
  end
end
end
end
end
