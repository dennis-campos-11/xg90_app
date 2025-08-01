class Team < ApplicationRecord
  has_many :season_teams
  has_many :seasons, through: :season_teams
  has_many :current_seasons, -> { Season.current }, through: :season_teams, source: :season
  has_many :current_competitions, through: :current_seasons, source: :competition
end
