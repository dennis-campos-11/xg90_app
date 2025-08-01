class Fixture < ApplicationRecord
  include DefineStatsMethods
  attr_accessor :home_processed_data, :away_processed_data

  enum :status, { not_started: 0, completed: 1 }

  belongs_to :competition
  belongs_to :season
  belongs_to :home, class_name: 'Team', foreign_key: 'home_id'
  belongs_to :away, class_name: 'Team', foreign_key: 'away_id'


  scope :next_matches, -> { where(starting_at: (Time.now - 4.days)..(Time.now + 3.days)) }

  def stats_by_team(team_id)
    home_id == team_id ? home_stats : away_stats
  end

  def facts_by_team(team_id)
    home_id == team_id ? home_facts : away_facts
  end
end
