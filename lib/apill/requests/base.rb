require 'apill/tokens/json_web_tokens/invalid'
require 'apill/tokens/json_web_token'

module  Apill
module  Requests
class   Base
  BASE64_PATTERN            = %r{[A-Za-z0-9_/\+\=\-\.]}
  BASE64_TOKEN_PARAM_NAME   = 'token_b64'
  TOKEN_PATTERN = %r{\A(?:Token (#{BASE64_PATTERN}+))?\z}

  attr_accessor :token_private_key,
                :request

  def initialize(token_private_key: Apill.configuration.token_private_key,
                 request:)

    self.token_private_key = token_private_key
    self.request           = request
  end

  def accept_header
    if accept_header_from_header.valid? ||
       accept_header_from_params.invalid?

      accept_header_from_header
    else
      accept_header_from_params
    end
  end

  def authorization_token
    if (
         !authorization_token_from_header.blank? &&
         authorization_token_from_header.valid?
    ) ||
    (
      authorization_token_from_params.blank? ||
      !authorization_token_from_params.valid?
    )

      authorization_token_from_header
    else
      authorization_token_from_params
    end
  end

  def application_name
    raw_request_application_name || Apill.configuration.application_name
  end

  def subdomain
    @subdomain ||= raw_host[/\A([a-z\-]+)/i, 1]
  end

  def self.resolve(original_request)
    if original_request.is_a? self
      original_request
    elsif original_request.respond_to? :headers
      rails_request_class.new(request: original_request)
    else
      rack_request_class.new(request: original_request)
    end
  end

  def self.rails_request_class
    require 'apill/requests/rails'

    Object.const_get('Apill::Requests::Rails')
  end

  def self.rack_request_class
    require 'apill/requests/rack'

    Object.const_get('Apill::Requests::Rack')
  end

  private

  def accept_header_from_header
    AcceptHeader.new(application: application_name,
                     header:      raw_accept_header_from_header || '')
  end

  def accept_header_from_params
    AcceptHeader.new(application: application_name,
                     header:      raw_accept_header_from_params || '')
  end

  def authorization_token_from_header
    return Tokens::JsonWebTokens::Invalid.instance \
      unless raw_authorization_header.match(TOKEN_PATTERN)

    Tokens::JsonWebToken.convert(
      token_private_key: token_private_key,
      raw_token:         raw_authorization_token_from_header || '')
  end

  def authorization_token_from_params
    Tokens::JsonWebToken.convert(
      token_private_key: token_private_key,
      raw_token:         raw_authorization_token_from_params || '')
  end

  private

  def raw_host
    request.fetch('HTTP_HOST', '')
  end

  def raw_authorization_token_from_header
    raw_authorization_header[TOKEN_PATTERN, 1] || ''
  end
end
end
end
