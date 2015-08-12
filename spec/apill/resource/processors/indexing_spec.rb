require 'rspectacular'
require 'apill/resource/processors/indexing'

module Apill
class  TestIndexClass
  def for_query(_param)
  end
end
end

module    Apill
module    Resource
module    Processors
describe  Indexing do
  let(:indexing_resource) { double }

  it 'does not do anything if indexing params are not passed in' do
    indexing = Indexing.new(indexing_resource)

    expect(indexing.processed).to eql indexing_resource
  end

  it 'forces a query even if no parameters were passed in' do
    indexing_resource = TestIndexClass.new
    indexing          = Indexing.new(indexing_resource)

    allow(indexing_resource).to receive(:for_query).
                                with('*').
                                and_return('blah')

    expect(indexing.processed).to eql 'blah'
  end
end
end
end
end
