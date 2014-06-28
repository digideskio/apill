require 'apill/accept_header'

module  Apill
module  Matchers
module  GenericMatcher
  attr_accessor :application,
                :accept_header

  def initialize(**args)
    args.each do |variable, value|
      self.send("#{variable}=", value)
    end
  end

  def matches?(request)
    self.accept_header = get_accept_header(raw_header_from_headers: request.headers['Accept'],
                                           raw_header_from_params:  request.params['accept'])
  end

  private

  def get_accept_header(raw_header_from_headers:, raw_header_from_params:)
    header_from_header = accept_header_from_header(raw_header_from_headers)

    return header_from_header if header_from_header.valid? || raw_header_from_params.nil?

    accept_header_from_header(raw_header_from_params)
  end

  def accept_header_from_header(raw_header_from_headers='')
    Apill::AcceptHeader.new(application:  application,
                            header:       raw_header_from_headers)
  end

  def accept_header_from_params(raw_header_from_params='')
    Apill::AcceptHeader.new(application:  application,
                            header:       raw_header_from_params)
  end
end
end
end
