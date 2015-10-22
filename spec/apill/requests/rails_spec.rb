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
                      'HTTP_AUTHORIZATION' => "Token #{valid_token}",
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

  it 'can process an authorization token if it is sent through incorrectly' do
    raw_request = OpenStruct.new(
                    headers: {
                      'HTTP_AUTHORIZATION' => "#{valid_token}",
                    },
                    params:  {})
    request     = Rails.new(token_private_key: test_private_key,
                            request:           raw_request)

    expect(request.authorization_token).not_to  be_valid
    expect(request.authorization_token.to_h).to eql([{}, {}])
  end

  it 'finds the authorization token from the params if the authorization token from ' \
     'the header is invalid and the authorization token from the params is valid' do

    raw_request = OpenStruct.new(
                    headers: {
                      'HTTP_AUTHORIZATION' => "Token #{invalid_token}",
                    },
                    params:  { 'token_jwt' => valid_token })
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
                    params:  { 'token_jwt' => valid_token })
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

  it 'finds the authorization token from the params' do
    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'token_jwt' => valid_token })
    request     = Rails.new(token_private_key: test_private_key,
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

    raw_request = OpenStruct.new(
                    headers: {},
                    params:  { 'accept' => 'application/vnd.zion+zion;version=10.0' })
    request     = Rails.new(request: raw_request)

    expect(request.accept_header.to_s).to eql 'application/vnd.zion+zion;version=10.0'
  end
end
end
end
