require 'spec_helper'
require 'apill/errors/invalid_api_request'

module    Apill
module    Errors
describe  InvalidApiRequest do
  let(:error) { InvalidApiRequest.new }

  it 'has a status of 400' do
    expect(error.http_status).to eql 400
  end

  it 'has a code' do
    expect(error.code).to eql 'errors.invalid_api_request'
  end

  it 'can output the detail' do
    expect(error.detail).to eql 'The accept header that you passed in the ' \
                                'request cannot be parsed, please refer to ' \
                                'the documentation to verify.'
  end

  it 'can output the source' do
    error = InvalidApiRequest.new accept_header: 'foo'

    expect(error.source).to eql(accept_header: 'foo')
  end
end
end
end
