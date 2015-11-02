require 'apill/authorizers/parameters'

module  Apill
module  Authorizers
class   Parameters
class   Filtering < Authorizers::Parameters
  def call
    params.permit(*authorized_params)
  end

  private

  def authorized_params
    @authorized_params ||= [
      :sort,
      page:   %i{
        number
        size
        offset
        limit
        cursor
      },
      filter: [
        :query,
        {},
      ],
    ]
  end

  def add_filterable_parameter(name)
    param = params.fetch(:filter, {}).
                   fetch(name,    nil)

    if param.class == Array
      authorized_params[1][:filter][1][name] = []
    else
      authorized_params[1][:filter] << name
    end
  end

  def add_filterable_parameters(*names)
    names.each do |name|
      add_filterable_parameter(name)
    end
  end
end
end
end
end
