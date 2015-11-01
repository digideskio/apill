require 'rspectacular'
require 'apill/authorizers/parameters/filtering'

module    Apill
module    Authorizers
class     Parameters
describe  Filtering do
  let(:params) { { filter: { name: 'Bill', age: 26 } } }

  it 'can authorize new filter parameters', verify: false do
    filter_params = Filtering.new(token:  '1234',
                                  user:   '1234',
                                  params: params)

    allow(params).to receive(:permit)

    filter_params.send(:add_filterable_parameters, :name, :age)
    filter_params.call

    expect(params).to have_received(:permit).
                      with(:sort, include(filter: include(:name, :age)))
  end

  it 'can authorize parameters if they come in as arrays', verify: false do
    params        = {
                      filter: {
                        name: 'Bill',
                        ary:  %w{hello},
                      }
                    }
    filter_params = Filtering.new(token:  '1234',
                                  user:   '1234',
                                  params: params)

    allow(params).to receive(:permit)

    filter_params.send(:add_filterable_parameters, :name, :ary)
    filter_params.call

    expect(params).to have_received(:permit).
                      with(:sort, include(filter: include(:name, ary: [])))
  end

  it 'has default authorized parameters', verify: false do
    filter_params = Filtering.new(token:  '1234',
                                  user:   '1234',
                                  params: params)

    allow(params).to receive(:permit)

    filter_params.call

    expect(params).to have_received(:permit).
                      with(:sort,
                           page:   %i{
                             number
                             size
                             offset
                             limit
                             cursor
                           },
                           filter: [
                             :query,
                             {}
                           ])
  end
end
end
end
end
