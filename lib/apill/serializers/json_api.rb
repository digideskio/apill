module  Apill
module  Serializers
module  JsonApi
  def json_api_type
    object.class.name.demodulize.tableize.dasherize
  end
end
end
end
