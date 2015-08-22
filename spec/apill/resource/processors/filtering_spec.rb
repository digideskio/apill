require 'rspectacular'
require 'apill/resource/processors/filtering'

module    Apill
module    Resource
module    Processors
describe  Filtering do
  let(:filtering_resource) { double }

  it 'can return the resource if not filtered parameters are passed in' do
    filtering = Filtering.new(filtering_resource)

    expect(filtering.processed).to eql filtering_resource
  end

  it 'can return a queried resource' do
    filtering = Filtering.new(filtering_resource,
                              'filter' => {
                                'stuff' => 'blah',
                              })

    allow(filtering_resource).to receive(:for_stuff).
                                 with('blah').
                                 and_return 'stuffed'

    expect(filtering.processed).to eql 'stuffed'
  end

  it 'does not try to query if the resource cannot query for that thing' do
    filtering = Filtering.new(filtering_resource,
                              'filter' => {
                                'whatever' => 'blah',
                              })

    expect(filtering.processed).to eql filtering_resource
  end

  it 'can query for something that does not take arguments' do
    filtering = Filtering.new(filtering_resource,
                              'filter' => {
                                'stuff' => 'blah',
                              })

    allow(filtering_resource).to receive(:stuff).
                                 and_return 'stuffed'

    expect(filtering.processed).to eql 'stuffed'
  end

  it 'can query for something that does not take arguments' do
    filtering = Filtering.new(filtering_resource,
                              'filter' => {
                                'stuff'       => 'blah',
                                'other_stuff' => 'other_blah',
                              })

    allow(filtering_resource).to receive(:for_stuff).
                                 with('blah').
                                 and_return filtering_resource
    allow(filtering_resource).to receive(:other_stuff).
                                 and_return 'other_stuffed'

    expect(filtering.processed).to eql 'other_stuffed'
  end

  it 'can properly format numerical ranges' do
    filtering = Filtering.new(filtering_resource,
                              'filter' => {
                                'stuff'       => '100...200',
                                'infinity'    => '9...Infinity',
                                'other_stuff' => '3_333.33..8_8__8.0',
                              })

    allow(filtering_resource).to receive(:for_stuff).
                                 with(100.0...200.0).
                                 and_return filtering_resource
    allow(filtering_resource).to receive(:infinity).
                                 with(9...Float::INFINITY).
                                 and_return filtering_resource
    allow(filtering_resource).to receive(:other_stuff).
                                 with(3333.33..888.0).
                                 and_return 'other_stuffed'

    expect(filtering.processed).to eql 'other_stuffed'
  end

  it 'can handle objects (eg ActiveRelation) that store their proxy class in klass' do
    resource_class = double
    filtering      = Filtering.new(filtering_resource,
                                   'filter' => {
                                     'stuff' => 'blah',
                                   })

    allow(filtering_resource).to receive(:klass).
                                 and_return(resource_class)
    allow(resource_class).to     receive(:stuff)
    allow(filtering_resource).to receive(:stuff).
                                 and_return 'stuffed'

    expect(filtering.processed).to eql 'stuffed'
  end
end
end
end
end
