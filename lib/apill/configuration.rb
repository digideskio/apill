module  Apill
  class Configuration
    attr_accessor \
      :allowed_subdomains,
      :allowed_api_subdomains,
      :application_name,
      :default_api_version

    def to_h
      {
        allowed_subdomains:  allowed_subdomains,
        application_name:    application_name,
        default_api_version: api_version,
        allowed_api_subdomains: allowed_api_subdomains,
      }
    end

    def allowed_api_subdomains
      @allowed_api_subdomains || ['api']
    end
  end

  def allowed_subdomains
    @allowed_subdomains || ['api']
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
