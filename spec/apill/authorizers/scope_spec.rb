require 'rspectacular'
require 'ostruct'
require 'apill/authorizers/scope'

module    Apill
module    Authorizers
describe  Scope do
  it 'defaults to nothing' do
    scope = Scope.new(token:          '123',
                      user:           'my_user',
                      scoped_user_id: '456',
                      params:         {},
                      scope_root:     OpenStruct.new(none: []))

    expect(scope.call).to be_empty
  end
end
end
end
