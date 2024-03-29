module  Apill
  class Configuration
    attr_accessor \
      :allowed_subdomains,
      :allowed_api_subdomains,
      :application_name,
      :default_api_version,
      :token_private_key

    def to_h
      {
        allowed_subdomains:     allowed_subdomains,
        allowed_api_subdomains: allowed_api_subdomains,
        application_name:       application_name,
        default_api_version:    default_api_version,
      }
    end

    def allowed_subdomains
      @allowed_subdomains || ['api']
    end

    def allowed_api_subdomains
      @allowed_api_subdomains || ['api']
    end
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
