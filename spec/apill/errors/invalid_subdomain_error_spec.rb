require 'rspectacular'
require 'apill/errors/invalid_subdomain_error'

module    Apill
module    Errors
describe  InvalidSubdomainError do
  let(:error) { InvalidSubdomainError.new }

  it 'has a status of 404' do
    expect(error.http_status).to eql 404
  end

  it 'has a code of 1010' do
    expect(error.code).to eql 1010
  end

  it 'has a knowledgebase article ID of 1234567890' do
    expect(error.knowledgebase_article_id).to eql '1234567890'
  end

  it 'can output the developer message' do
    expect(error.developer_message).to eql \
      'The resource you attempted to access is either not authorized for the ' \
      'authenticated user or does not exist.'
  end

  it 'can output the developer details' do
    error = InvalidSubdomainError.new http_host: 'foo'

    expect(error.developer_details).to eql(http_host: 'foo')
  end

  it 'can output the friendly message' do
    expect(error.friendly_message).to eql \
      'Sorry! The resource you tried to access does not exist.'
  end
end
end
end
