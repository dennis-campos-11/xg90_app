class TeamFixturesQuery
  include SampleTypes
  attr_reader :location, :sample, :team_id, :competition_id

  def self.call(filters = {})
    new(filters).call
  end

  def initialize(filters = {})
    @team_id        = filters[:team_id]
    @competition_id = filters[:competition_id]
    @location       = filters[:location]&.to_sym
    @sample         = filters[:sample]&.to_sym
  end

  def call
    scope = Fixture.includes(:season).completed.order(starting_at: :desc)
    scope = by_location(scope)
    scope = by_sample(scope)
    by_competition(scope)
  end

  private

  def by_location(scope)
    case location
    when :home
      scope.where(home_id: team_id)
    when :away
      scope.where(away_id: team_id)
    when :both
      scope.where("home_id = :team_id OR away_id = :team_id", team_id: team_id)
    else
      scope
    end
  end

  def by_sample(scope)
    if SAMPLE_BY_TOTAL_GAMES.key?(sample)
      scope.limit(SAMPLE_BY_TOTAL_GAMES[sample])
    elsif SAMPLE_BY_SEASON.key?(sample)
      scope.joins(:season).where("seasons.index <= ?", SAMPLE_BY_SEASON[sample])
    else
      scope
    end
  end

  def by_competition(scope)
    return scope if competition_id.nil?

    scope.where(competition_id:)
  end

end
