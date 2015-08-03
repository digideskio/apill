module  Apill
class   Parameters
  attr_accessor :query_string

  def initialize(query_string)
    self.query_string = query_string
  end

  def self.process(query_string)
    new(query_string).process
  end

  def process
    return query_string unless query_string.respond_to? :gsub

    query_string.gsub(/(?<=\A|&|\?)[^=&]+/) do |match|
      match.gsub!('-', '_')
    end
  end
end
end
