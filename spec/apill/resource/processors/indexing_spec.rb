require 'rspectacular'
require 'apill/resource/processors/indexing'

module    Apill
module    Resource
module    Processors
describe  Indexing do
  let(:indexing_resource) { double }

  it 'does not do anything if indexing params are not passed in' do
    indexing = Indexing.new(indexing_resource)

    expect(indexing.processed).to eql indexing_resource
  end
end
end
end
end
