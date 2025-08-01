module EnumOptions
  extend ActiveSupport::Concern

  class_methods do
    def enum_options(attribute)
      send(attribute.to_s.pluralize).map { |key, id| { id: id, value: key } }
    end
  end
end