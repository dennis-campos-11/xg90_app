class TeamProcessedDatum < ApplicationRecord
  include ProcessedDatumCommon

  belongs_to :team
  belongs_to :competition, optional: true
end
