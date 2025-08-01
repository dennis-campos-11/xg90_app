class Season < ApplicationRecord
  has_many :season_teams
  has_many :teams, through: :season_teams
  belongs_to :competition

  scope :current, -> { where(index: 0) }
end
