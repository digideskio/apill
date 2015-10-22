require 'spec_helper'
require 'apill/requests/rack'

module    Apill
module    Requests
describe  Rack do
  it 'finds the accept header from the headers if it is valid' do
    raw_request = {
      'HTTP_ACCEPT'             => 'application/vnd.matrix+zion;version=10.0',
      'QUERY_STRING'            => '',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request     = Rack.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the headers if it is invalid but there is no ' \
     'accept header in the params' do

    raw_request = {
      'HTTP_ACCEPT'             => 'invalid/vnd.matrix+zion;version=10.0',
      'QUERY_STRING'            => '',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request     = Rack.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'invalid/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the params if it is valid' do
    raw_request = {
      'HTTP_ACCEPT'             => '',
      'QUERY_STRING'            => 'accept=application/vnd.matrix+zion;version=10.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request     = Rack.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  # rubocop:disable Metrics/LineLength
  it 'finds the accept header from the query string if it is encoded' do
    raw_request = {
      'HTTP_ACCEPT'             => '',
      'QUERY_STRING'            => 'accept=application%2Fvnd.matrix%2Bzion%3Bversion%3D10.0',
      'HTTP_X_APPLICATION_NAME' => 'matrix',
    }
    request     = Rack.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end
  # rubocop:enable Metrics/LineLength

  it 'finds the authorization token from the header' do
    raw_request = {
      'HTTP_AUTHORIZATION' => "Token #{valid_jwt_token}",
      'QUERY_STRING'       => '',
    }
    request     = Rack.new(token_private_key: test_private_key,
                           request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'bar' => 'baz' },
        { 'typ' => 'JWT', 'alg' => 'RS256' },
      ])
  end

  it 'can process an authorization token if it is sent through incorrectly' do
    raw_request = {
      'HTTP_AUTHORIZATION' => "#{valid_jwt_token}",
      'QUERY_STRING'       => '',
    }
    request     = Rack.new(token_private_key: test_private_key,
                           request:           raw_request)

    expect(request.authorization_token).not_to  be_valid
    expect(request.authorization_token.to_h).to eql([{}, {}])
  end

  it 'finds the authorization token from the params if the authorization token from ' \
     'the header is invalid and the authorization token from the params is valid' do

    raw_request = {
      'HTTP_AUTHORIZATION' => "Token #{invalid_jwt_token}",
      'QUERY_STRING'       => "token_jwt=#{valid_jwt_token}",
    }
    request     = Rack.new(token_private_key: test_private_key,
                           request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'bar' => 'baz' },
        { 'typ' => 'JWT', 'alg' => 'RS256' },
      ])
  end

  it 'finds the authorization token from the params if the authorization token from ' \
     'the header is not present and the authorization token from the params is valid' do

    raw_request = {
      'QUERY_STRING' => "token_jwt=#{valid_jwt_token}",
    }
    request     = Rack.new(token_private_key: test_private_key,
                           request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'bar' => 'baz' },
        { 'typ' => 'JWT', 'alg' => 'RS256' },
      ])
  end

  it 'is a null authorization token if neither authorization token is present' do
    raw_request = {
      'QUERY_STRING' => '',
    }
    request     = Rack.new(token_private_key: test_private_key,
                           request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql([{}, {}])
  end

  it 'finds the authorization token from the params' do
    raw_request = {
      'QUERY_STRING' => "token_jwt=#{valid_jwt_token}",
    }
    request     = Rack.new(token_private_key: test_private_key,
                           request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'bar' => 'baz' },
        { 'typ' => 'JWT', 'alg' => 'RS256' },
      ])
  end

  it 'defaults to the application name in the configuration if none is found in ' \
     'the header' do

    Apill.configuration.application_name = 'zion'

    raw_request = {
      'HTTP_ACCEPT'  => '',
      'QUERY_STRING' => 'accept=application/vnd.zion+zion;version=10.0',
    }
    request     = Rack.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.zion+zion;version=10.0'
  end
end
end
end
