class DataField < ApplicationRecord
  enum :field_type, { statistic: 1, fact: 2, probability: 3 }
  enum :half_type, { ft: 1, '1h': 2, '2h': 3 }

  default_scope { order(code: :asc) }

  def label
    I18n.t("data_fields.#{code}", default: code.humanize)
  end
end
