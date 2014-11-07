require 'apill/configuration'
require 'apill/matchers/generic_matcher'

module  Apill
module  Matchers
class   VersionMatcher
  include GenericMatcher

  attr_accessor :version_constraint,
                :default_version

  def matches?(request)
    super

    requested_version == version_constraint
  end

  private

  def requested_version
    accept_header.version || default_version
  end

  def default_version
    @default_version || Apill.configuration.default_api_version
  end
end
end
end
