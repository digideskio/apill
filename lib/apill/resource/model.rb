require 'apill/resource/processors/filtering'
require 'apill/resource/processors/sorting'
require 'apill/resource/processors/paging'
require 'apill/resource/processors/indexing'

module  Apill
module  Resource
class   Model
  DEFAULT_PROCESSORS = %w{filtering sorting paging indexing}.freeze

  attr_accessor :resource,
                :parameters,
                :processors

  def initialize(resource:, parameters:, **options)
    self.resource   = resource
    self.parameters = parameters.dup
    self.processors = options.fetch(:processors, DEFAULT_PROCESSORS)
  end

  def processed
    @processed ||= \
      processors.inject(resource) do |processed_resource, processor|
        processor.processed(processed_resource, parameters)
      end
  end

  def meta
    @meta ||= \
      processors.inject({}) do |metadata, processor|
        metadata.merge processor.meta(processed, parameters)
      end
  end

  def processors=(other)
    @processors = other.map do |processor|
      Object.const_get "::Apill::Resource::Processors::#{processor.capitalize}"
    end
  end
end
end
end
