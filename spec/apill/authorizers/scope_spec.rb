require 'rspectacular'
require 'ostruct'
require 'apill/authorizers/scope'

module    Apill
module    Authorizers
describe  Scope do
  it 'defaults to nothing' do
    scope = Scope.new(token:             '123',
                      user:              'my_user',
                      requested_user_id: '456',
                      scope_root:        OpenStruct.new(none: []))

    expect(scope.call).to be_empty
  end
end
end
end
