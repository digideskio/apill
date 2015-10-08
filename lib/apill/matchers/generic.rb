module  Apill
module  Matchers
module  Generic
  attr_accessor :application,
                :accept_header,
                :request

  def initialize(request:, **args)
    args.each do |variable, value|
      __send__("#{variable}=", value)
    end

    self.request       = request
    self.application   = request.application_name
    self.accept_header = request.accept_header
  end
end
end
end
