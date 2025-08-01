module ProcessedDatumCommon
  extend ActiveSupport::Concern

  included do
    attribute :location, :integer
    attribute :sample, :integer

    enum :location, { home: 1, away: 2, both: 3 }
    enum :sample, {
      last_5_games: 1,
      last_10_games: 2,
      last_15_games: 3,
      current_season: 4,
      last_season: 5,
      last_2_seasons: 6,
      last_3_seasons: 7
    }
  end
end