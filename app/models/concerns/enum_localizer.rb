module EnumLocalizer
  extend ActiveSupport::Concern

  class_methods do
    def localized_enum(enum_name)
      public_send(enum_name).map do |key, value|
        {
          id: value,
          value: key.to_s,
          label: I18n.t("enums.#{model_name.i18n_key}.#{enum_name}.#{key}", default: key.to_s.humanize)
        }
      end
    end
  end
end