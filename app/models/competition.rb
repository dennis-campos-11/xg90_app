class Competition < ApplicationRecord
  belongs_to :country
  has_one :current_season, -> { Season.current }, class_name: 'Season'
  has_one :home_grouped_teams_processed_data, -> { distinct }, class_name: "GroupedTeamsProcessedDatum", foreign_key: "competition_id"
  has_one :away_grouped_teams_processed_data, -> { distinct }, class_name: "GroupedTeamsProcessedDatum", foreign_key: "competition_id"
end
