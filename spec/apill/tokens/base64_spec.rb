require 'spec_helper'
require 'apill/tokens/base64'

module    Apill
module    Tokens
describe  Base64 do
  it 'is valid' do
    expect(Base64.new(token: 'foo')).to be_valid
  end

  it 'is not blank' do
    expect(Base64.new(token: 'foo')).not_to be_blank
  end

  it 'can convert itself into a hash' do
    token = Base64.new(token: 'foo')

    expect(token.to_h).to eql([
      {
        'token' => 'foo',
      },
      {
        'typ' => 'base64',
      },
    ])
  end
end
end
end
