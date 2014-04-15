require 'rspectacular'
require 'apill/errors/invalid_api_request_error'

module    Apill
module    Errors
describe  InvalidApiRequestError do
  let(:error) { InvalidApiRequestError.new }

  it 'has a status of 400' do
    expect(error.http_status).to eql 400
  end

  it 'has a code of 1007' do
    expect(error.code).to eql 1007
  end

  it 'has a knowledgebase article ID of 1234567890' do
    expect(error.knowledgebase_article_id).to eql '1234567890'
  end

  it 'can output the developer message' do
    expect(error.developer_message).to eql 'The accept header that you passed in the request cannot be parsed, please refer to the documentation to verify.'
  end

  it 'can output the developer details' do
    error = InvalidApiRequestError.new accept_header: 'foo'

    expect(error.developer_details).to eql(accept_header: 'foo')
  end

  it 'can output the friendly message' do
    expect(error.friendly_message).to eql "Sorry! We couldn't understand what you were trying to ask us to do."
  end
end
end
end
