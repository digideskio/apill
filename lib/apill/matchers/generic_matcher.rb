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
    self.accept_header = Apill::AcceptHeader.new(application:  application,
                                                 header:       request.headers['Accept'])
  end
end
end
end
