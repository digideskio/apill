require 'rspectacular'
require 'apill/resource/model'

module    Apill
module    Resource
describe  Model do
  it 'can chain multiple processors together' do
    resource           = double
    processed_resource = double

    model = Model.new(resource:   resource,
                      parameters: {
                        'filter'  => {
                          'query'          => 'my_query',
                          'single_arity'   => true,
                          'multiple_arity' => 'multi',
                        },
                        'include' => %w{my_association my_other_association},
                        'sort'    => 'my_attribute',
                        'page'    => {
                          'number' => 10,
                          'size'   => 100,
                        },
                      })

    allow(resource).to receive(:single_arity).
                       and_return(resource)
    allow(resource).to receive(:multiple_arity).
                       with('multi').
                       and_return(resource)
    allow(resource).to receive(:order).
                       with('my_attribute' => 'asc').
                       and_return(resource)
    allow(resource).to receive(:page).
                       with(10).
                       and_return(resource)
    allow(resource).to receive(:per).
                       with(100).
                       and_return(resource)
    allow(resource).to receive(:for_query).
                       with('my_query').
                       and_return(processed_resource)

    allow(processed_resource).to receive(:total_pages).
                       and_return(10)
    allow(processed_resource).to receive(:current_page).
                       and_return(5)
    allow(processed_resource).to receive(:prev_page).
                       and_return(4)
    allow(processed_resource).to receive(:next_page).
                       and_return(6)

    expect(model.processed).to eql processed_resource
    expect(model.processed).to eql processed_resource
    expect(model.include).to   eql %w{my_association my_other_association}

    expect(model.meta).to      eql(
      'current-page'  => 5,
      'total-pages'   => 10,
      'previous-page' => 4,
      'next-page'     => 6,
      'sort'          => { 'my_attribute' => 'asc' },
    )
  end
end
end
end
