class GroupedTeamsProcessedDatum < ApplicationRecord
  include ProcessedDatumCommon

  belongs_to :competition

  scope :by_location, ->(location) { where(location: location) if location.present? }
  scope :by_sample, ->(sample) { where(sample: sample) if sample.present? }
end
