require 'rspectacular'
require 'apill/authorizers/query'

module    Apill
module    Authorizers
describe  Query do
  it 'does not authorize the resource by default' do
    authorizer = Query.new(token:    '123',
                           user:     'my_user',
                           resource: 'my_resource')

    expect(authorizer).to     be_able_to_index
    expect(authorizer).not_to be_able_to_show
    expect(authorizer).not_to be_able_to_create
    expect(authorizer).not_to be_able_to_update
    expect(authorizer).not_to be_able_to_destroy
  end
end
end
end
