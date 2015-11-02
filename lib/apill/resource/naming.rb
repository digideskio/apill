module  Apill
module  Resource
module  Naming
  CONTROLLER_RESOURCE_NAME_PATTERN = /\A((.*?::)?.*?)(\w+)Controller\z/

  module ClassMethods
    def plural_resource_name
      @plural_resource_name ||= name[CONTROLLER_RESOURCE_NAME_PATTERN, 3].
                                underscore.
                                pluralize.
                                downcase
    end

    def singular_resource_name
      @singular_resource_name ||= name[CONTROLLER_RESOURCE_NAME_PATTERN, 3].
                                  underscore.
                                  singularize.
                                  downcase
    end

    def resource_class_name
      @resource_class_name ||= singular_resource_name.
                               camelize
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
end
end
