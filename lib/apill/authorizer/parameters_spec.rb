require 'rspectacular'
require 'apill/authorizer/parameters'

module    Apill
module    Authorizer
describe  Parameters do
  it 'defaults to nothing' do
    parameters = Parameters.new(token:  '123',
                                user:   'my_user',
                                params: {foo: 'bar'})

    expect(parameters.call).to eql({foo: 'bar'})
  end
end
end
end
