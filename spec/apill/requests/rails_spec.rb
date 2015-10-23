require 'ostruct'
require 'spec_helper'
require 'apill/requests/rails'

module    Apill
module    Requests
describe  Rails do
  it 'finds the accept header from the headers if it is valid' do
    raw_request = OpenStruct.new(
                    headers: {
                      'X-Application-Name' => 'matrix',
                      'Accept'             => 'application/vnd.matrix+zion;version=10.0',
                    },
                    params:  {})
    request     = Rails.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the headers if it is invalid but there is no ' \
     'accept header in the params' do

    raw_request = OpenStruct.new(
                    headers: {
                      'X-Application-Name' => 'matrix',
                      'Accept'             => 'invalid/vnd.matrix+zion;version=10.0',
                    },
                    params:  {})
    request     = Rails.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'invalid/vnd.matrix+zion;version=10.0'
  end

  it 'finds the accept header from the params if it is valid' do
    raw_request = OpenStruct.new(
                    headers: {
                      'X-Application-Name' => 'matrix',
                    },
                    params:  { 'accept' => 'application/vnd.matrix+zion;version=10.0' })
    request     = Rails.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.matrix+zion;version=10.0'
  end

  it 'finds the authorization token from the header' do
    raw_request = OpenStruct.new(
                    headers: {
                      'HTTP_AUTHORIZATION' => "Token #{valid_jwt_token}",
                    },
                    params:  {})
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'bar' => 'baz' },
        { 'typ' => 'JWT', 'alg' => 'RS256' },
      ])
  end

  it 'finds the Base64 token from the header' do
    raw_request = OpenStruct.new(
                    headers: {
                      'HTTP_AUTHORIZATION' => "Basic #{valid_b64_token}",
                    },
                    params:  {})
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'token' => valid_b64_token },
        { 'typ'   => 'base64' },
      ])
  end

  it 'finds a null token from the header if there is no header' do
    raw_request = OpenStruct.new(
                    headers: {},
                    params:  {})
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).to be_valid
    expect(request.authorization_token).to be_blank
  end

  it 'ignores incorrectly passed in tokens since we do not know what to do' do
    raw_request = OpenStruct.new(
                    headers: {
                      'HTTP_AUTHORIZATION' => "#{valid_jwt_token}",
                    },
                    params:  {})
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).to be_valid
    expect(request.authorization_token).to be_blank
  end

  it 'finds the authorization token from the params if the authorization token from ' \
     'the header is invalid and the authorization token from the params is valid' do

    raw_request = OpenStruct.new(
                    headers: {
                      'HTTP_AUTHORIZATION' => "Token #{invalid_jwt_token}",
                    },
                    params:  { 'token_jwt' => valid_jwt_token })
    request     = Rails.new(token_private_key: test_private_key,
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

    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_jwt' => valid_jwt_token })
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'bar' => 'baz' },
        { 'typ' => 'JWT', 'alg' => 'RS256' },
      ])
  end

  it 'is a null authorization token if neither authorization token is present' do
    raw_request = OpenStruct.new(
                    headers: {},
                    params:  {})
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql([{}, {}])
  end

  it 'finds the JSON web token from the params' do
    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_jwt' => valid_jwt_token })
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'bar' => 'baz' },
        { 'typ' => 'JWT', 'alg' => 'RS256' },
      ])
  end

  it 'finds the generic Base64 web token from the params' do
    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_b64' => valid_b64_token })
    request     = Rails.new(request: raw_request)

    expect(request.authorization_token).to      be_valid
    expect(request.authorization_token.to_h).to eql(
      [
        { 'token' => valid_b64_token },
        { 'typ'   => 'base64' },
      ])
  end

  it 'finds invalid tokens from the params' do
    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_b64' => 'bla.h' })
    request     = Rails.new(request: raw_request)

    expect(request.authorization_token_from_params).not_to be_valid
    expect(request.authorization_token_from_params).not_to be_blank

    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_jwt' => invalid_jwt_token })
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token_from_params).not_to be_valid
    expect(request.authorization_token_from_params).not_to be_blank
  end

  it 'finds the null token from the params if nothing is passed in' do
    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_b64' => '' })
    request     = Rails.new(request: raw_request)

    expect(request.authorization_token_from_params).to be_valid
    expect(request.authorization_token_from_params).to be_blank

    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_jwt' => '' })
    request     = Rails.new(request: raw_request)

    expect(request.authorization_token_from_params).to be_valid
    expect(request.authorization_token_from_params).to be_blank

    raw_request = OpenStruct.new(
                    headers: {},
                    params:  {})
    request     = Rails.new(request: raw_request)

    expect(request.authorization_token_from_params).to be_valid
    expect(request.authorization_token_from_params).to be_blank
  end

  it 'defaults to the application name in the configuration if none is found in ' \
     'the header' do

    Apill.configuration.application_name = 'zion'

    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'accept' => 'application/vnd.zion+zion;version=10.0' })
    request     = Rails.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.zion+zion;version=10.0'
  end
end
end
end
