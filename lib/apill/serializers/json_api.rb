module  Apill
module  Serializers
module  JsonApi
  def type
    object.class.name.demodulize.tableize.dasherize
  end
end
end
end
