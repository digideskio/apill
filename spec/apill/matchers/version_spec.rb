require 'spec_helper'
require 'apill/requests/base'
require 'apill/matchers/version'

module    Apill
module    Matchers
describe  Version do
  context 'when the version is passed in the accept header' do
    it 'does not match if the subdomain is API but the requested version does not ' \
       'equal the version constraint' do

      env     = {
        'HTTP_X_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'             => 'application/vnd.matrix+zion;version=10.0',
      }
      request = Requests::Base.resolve(env)

      matcher = Version.new(version_constraint: '10.1')

      expect(matcher.matches?(request)).to be_a FalseClass
    end

    it 'does match if the subdomain is API and the requested version equals the ' \
       'version constraint' do

      env     = {
        'HTTP_X_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'             => 'application/vnd.matrix+zion;version=10.0',
      }
      request = Requests::Base.resolve(env)

      matcher = Version.new(version_constraint: '10.0')

      expect(matcher.matches?(request)).to be_a TrueClass
    end
  end

  context 'when the version is not passed in the accept header' do
    it 'does not match if the subdomain is API but the requested version does not ' \
       'equal the version constraint' do

      env     = {
        'HTTP_X_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'             => 'application/vnd.matrix+zion',
      }
      request = Requests::Base.resolve(env)

      matcher = Version.new(version_constraint: '10.1',
                            default_version:    '10.0')

      expect(matcher.matches?(request)).to be_a FalseClass
    end

    it 'does match if the subdomain is API and the requested version equals the ' \
       'version constraint' do

      env     = {
        'HTTP_X_APPLICATION_NAME' => 'matrix',
        'HTTP_ACCEPT'             => 'application/vnd.matrix+zion',
      }
      request = Requests::Base.resolve(env)

      matcher = Version.new(version_constraint: '10.0',
                            default_version:    '10.0')

      expect(matcher.matches?(request)).to be_a TrueClass
    end
  end

  it 'matches the default version in the configuration if none is passed in' do
    Apill.configuration.default_api_version = '100.0'

    env     = {
      'HTTP_X_APPLICATION_NAME' => 'matrix',
      'HTTP_ACCEPT'             => 'application/vnd.matrix+zion',
    }
    request = Requests::Base.resolve(env)

    matcher = Version.new(version_constraint: '100.0')

    expect(matcher.matches?(request)).to be_a TrueClass
  end
end
end
end
