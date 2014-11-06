require 'rspectacular'
require 'apill/matchers/version_matcher'

module    Apill
module    Matchers
describe  VersionMatcher do
  context 'when the version is passed in the accept header' do
    it 'does not match if the subdomain is API but the requested version does not ' \
       'equal the version constraint' do

      request = {
        'API_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'          => 'application/vnd.matrix+zion;version=10.0',
      }

      matcher = VersionMatcher.new(version_constraint: '10.1')

      expect(matcher.matches?(request)).to be_a FalseClass
    end

    it 'does match if the subdomain is API and the requested version equals the ' \
       'version constraint' do

      request = {
        'API_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'          => 'application/vnd.matrix+zion;version=10.0',
      }

      matcher = VersionMatcher.new(version_constraint: '10.0')

      expect(matcher.matches?(request)).to be_a TrueClass
    end
  end

  context 'when the version is not passed in the accept header' do
    it 'does not match if the subdomain is API but the requested version does not ' \
       'equal the version constraint' do

      request = {
        'API_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'          => 'application/vnd.matrix+zion',
      }

      matcher = VersionMatcher.new(version_constraint: '10.1',
                                   default_version:    '10.0')

      expect(matcher.matches?(request)).to be_a FalseClass
    end

    it 'does match if the subdomain is API and the requested version equals the ' \
       'version constraint' do

      request = {
        'API_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'          => 'application/vnd.matrix+zion',
      }

      matcher = VersionMatcher.new(version_constraint: '10.0',
                                   default_version:    '10.0')

      expect(matcher.matches?(request)).to be_a TrueClass
    end
  end
end
end
end