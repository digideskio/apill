require 'apill/matchers/generic_matcher'
require 'apill/errors/invalid_api_request_error'

module  Apill
module  Matchers
class   VersionMatcher
  include Apill::Matchers::GenericMatcher

  attr_accessor :version_constraint,
                :default_version

  def matches?(request)
    super

    raise Apill::Errors::InvalidApiRequestError unless accept_header.valid?

    request.subdomains.first == 'api' &&
    requested_version        == version_constraint
  end

  private

  def requested_version
    accept_header.version || default_version
  end
end
end
end
