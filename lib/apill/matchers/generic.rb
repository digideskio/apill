module  Apill
module  Matchers
module  Generic
  attr_accessor :application,
                :accept_header,
                :request

  def initialize(**args)
    args.each do |variable, value|
      __send__("#{variable}=", value)
    end
  end

  def matches?(request)
    self.request = request
  end

  def application
    request.application_name
  end

  def accept_header
    request.accept_header
  end
end
end
end
