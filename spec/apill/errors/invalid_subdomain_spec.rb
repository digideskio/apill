require 'spec_helper'
require 'apill/errors/invalid_subdomain'

module    Apill
module    Errors
describe  InvalidSubdomain do
  let(:error) { InvalidSubdomain.new }

  it 'has a status of 404' do
    expect(error.http_status).to eql 404
  end

  it 'has a code' do
    expect(error.code).to eql 'errors.invalid_subdomain'
  end

  it 'can output the detail' do
    expect(error.detail).to eql \
      'The resource you attempted to access is either not authorized for the ' \
      'authenticated user or does not exist.'
  end

  it 'can output the source' do
    error = InvalidSubdomain.new http_host: 'foo'

    expect(error.source).to eql(http_host: 'foo')
  end
end
end
end
