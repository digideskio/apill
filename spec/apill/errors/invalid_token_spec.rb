require 'spec_helper'
require 'apill/errors/invalid_token'

module    Apill
module    Errors
describe  InvalidToken do
  let(:error) { InvalidToken.new }

  it 'has a status of 401' do
    expect(error.http_status).to eql 401
  end

  it 'has a code' do
    expect(error.code).to eql 'errors.invalid_token'
  end

  it 'can output the detail' do
    expect(error.detail).to eql \
      'Either the token you passed is invalid or is not allowed to perform this action.'
  end
end
end
end
