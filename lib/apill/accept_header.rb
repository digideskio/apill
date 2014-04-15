module  Apill
class   AcceptHeader
  attr_accessor :application,
                :raw_accept_header

  def initialize(application:, header:)
    self.application       = application
    self.raw_accept_header = header
  end

  def version
    accept_header_data[2]
  end

  def content_type
    accept_header_data[1]
  end

  def valid?
    !accept_header_data.nil?
  end

  private

  def accept_header_data
    raw_accept_header.match(accept_header_format)
  end

  def accept_header_format
    %r{\Aapplication/#{application_vendor}(?:\+(\w+))?(?:;version=(#{version_format}))?\z}
  end

  def application_vendor
    "vnd\\.#{application}"
  end

  def version_format
    "\\d+(?:\\.\\d+){0,2}(?:beta(?:\\d*))?"
  end
end
end
