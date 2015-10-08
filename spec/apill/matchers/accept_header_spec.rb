require 'spec_helper'
require 'apill/requests/base'
require 'apill/matchers/accept_header'

module    Apill
module    Matchers
describe  AcceptHeader do
  it 'matches if the subdomain is API and the accept header is valid' do
    env = {
      'HTTP_ACCEPT'             => 'application/vnd.matrix+zion;version=1.0.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request = Requests::Base.resolve(env)

    matcher = AcceptHeader.new(request: request)

    expect(matcher).to be_matches
  end

  it 'matches if the subdomain is API and the accept header is passed in as ' \
     'a parameter' do

    env = {
      'QUERY_STRING'            => 'accept=application/vnd.matrix+zion;version=1.0.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request = Requests::Base.resolve(env)

    matcher = AcceptHeader.new(request: request)

    expect(matcher).to be_matches
  end

  it 'matches if the subdomain is API and the accept header is passed in as a ' \
     'secondary parameter' do

    env = {
      'QUERY_STRING'            => 'first=my_param&accept=application/vnd.matrix+zion;' \
                                   'version=1.0.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request = Requests::Base.resolve(env)

    matcher = AcceptHeader.new(request: request)

    expect(matcher).to be_matches
  end

  it 'matches the header accept header if the subdomain is API and the accept header ' \
     'is passed both as a valid header and as a parameter' do

    env = {
      'HTTP_ACCEPT'             => 'application/vnd.matrix+zion;version=1.0.0',
      'QUERY_STRING'            => 'accept=application/vnd.matrix+zion;version=2.0.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request = Requests::Base.resolve(env)

    matcher = AcceptHeader.new(request: request)
    matcher.matches?

    expect(matcher.accept_header.version).to eql '1.0.0'
  end

  it 'matches the accept header parameter if the subdomain is API and the accept ' \
     'header is passed both as an invalid header as well as as a parameter' do

    env = {
      'HTTP_ACCEPT'             => 'application/vndmatrix+zion;version=1.0.0',
      'QUERY_STRING'            => 'accept=application/vnd.matrix+zion;version=2.0.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request = Requests::Base.resolve(env)

    matcher = AcceptHeader.new(request: request)
    matcher.matches?

    expect(matcher.accept_header.version).to eql '2.0.0'
  end

  it 'matches the accept header parameter if the subdomain is API and the accept ' \
     'header is passed both as an invalid header as well as as a parameter' do

    env = {
      'HTTP_ACCEPT'             => 'application/vndmatrix+zion;version=1.0.0',
      'QUERY_STRING'            => '',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request = Requests::Base.resolve(env)

    matcher = AcceptHeader.new(request: request)
    matcher.matches?

    expect(matcher.accept_header.raw_accept_header).to eql \
      'application/vndmatrix+zion;version=1.0.0'
  end

  it 'does not match if the subdomain is API but the accept header is invalid' do
    env = {
      'HTTP_ACCEPT'             => 'application/vndmatrix+zion;version=1.0.0',
      'QUERY_STRING'            => '',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request = Requests::Base.resolve(env)

    matcher = AcceptHeader.new(request: request)

    expect(matcher).not_to be_matches
  end
end
end
end
