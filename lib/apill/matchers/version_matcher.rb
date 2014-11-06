require 'apill/matchers/generic_matcher'

module  Apill
module  Matchers
class   VersionMatcher
  include Apill::Matchers::GenericMatcher

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
end
end
end
