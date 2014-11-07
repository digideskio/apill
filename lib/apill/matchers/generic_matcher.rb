require 'apill/accept_header'
require 'apill/requests/base'

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
    request            = Requests::Base.resolve(request)
    self.application   = request.application_name
    self.accept_header = request.accept_header
  end
end
end
end
