require 'spec_helper'
require 'apill/resource/processors/sorting'

module    Apill
module    Resource
module    Processors
describe  Sorting do
  let(:sorting_resource) { double }

  it 'can return an ascending sort' do
    sorting = Sorting.new(sorting_resource, 'sort' => 'my_attribute')

    allow(sorting_resource).to receive(:order).
                               with('my_attribute' => 'asc').
                               and_return('sorted')

    expect(sorting.processed).to eql 'sorted'
    expect(sorting.meta).to      eql(
      'sort' => {
        'my_attribute' => 'asc',
      },
    )
  end

  it 'can return a descending sort' do
    sorting = Sorting.new(sorting_resource, 'sort' => '-my_attribute')

    allow(sorting_resource).to receive(:order).
                               with('my_attribute' => 'desc').
                               and_return('sorted')

    expect(sorting.processed).to eql 'sorted'
    expect(sorting.meta).to eql(
      'sort' => {
        'my_attribute' => 'desc',
      },
    )
  end

  it 'can return multiple sorts' do
    sorting = Sorting.new(sorting_resource, 'sort' => '-my_attribute,my_other_attribute')

    allow(sorting_resource).to receive(:order).
                               with('my_attribute'       => 'desc',
                                    'my_other_attribute' => 'asc').
                               and_return('sorted')

    expect(sorting.processed).to eql 'sorted'
    expect(sorting.meta).to eql(
      'sort' => {
        'my_attribute'       => 'desc',
        'my_other_attribute' => 'asc',
      },
    )
  end

  it 'does not do anything if sorting params are not passed in' do
    sorting = Sorting.new(sorting_resource)

    expect(sorting.processed).to eql sorting_resource
  end
end
end
end
end
