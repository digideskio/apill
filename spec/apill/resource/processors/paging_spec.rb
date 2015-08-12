require 'rspectacular'
require 'apill/resource/processors/paging'

module    Apill
module    Resource
module    Processors
describe  Paging do
  let(:paging_resource)    { double }
  let(:processed_resource) { double }

  it 'can return a default page' do
    paging = Paging.new(paging_resource,
                        'page' => {
                          'size' => 10,
                        })

    allow(processed_resource).to receive(:total_pages).and_return  10
    allow(processed_resource).to receive(:current_page).and_return 1
    allow(processed_resource).to receive(:prev_page).and_return    nil
    allow(processed_resource).to receive(:next_page).and_return    nil

    allow(paging_resource).to receive(:page).
                              with(1).
                              and_return paging_resource
    allow(paging_resource).to receive(:per).
                              with(10).
                              and_return processed_resource

    expect(paging.processed).to eql processed_resource
    expect(paging.meta).to      eql(
      'total-pages'   => 10,
      'current-page'  => 1,
      'previous-page' => nil,
      'next-page'     => nil,
    )
  end

  it 'can return a pageed resource' do
    paging = Paging.new(paging_resource,
                        'page' => {
                          'number' => 5,
                          'size'   => 10,
                        })

    allow(paging_resource).to receive(:page).
                              with(5).
                              and_return paging_resource
    allow(paging_resource).to receive(:per).
                              with(10).
                              and_return processed_resource

    expect(paging.processed).to eql processed_resource
  end

  it 'does not do anything if page params are not passed in' do
    paging = Paging.new(paging_resource)

    expect(paging.processed).to eql paging_resource
  end
end
end
end
end
