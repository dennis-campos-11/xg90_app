class FixtureListQuery
  attr_reader :fixture_list

  def self.call(fixture_list:)
    new(fixture_list).call
  end

  def initialize(fixture_list)
    @fixture_list = fixture_list
  end

  def call
    scope = Fixture.select(select_with_processed_data)
                   .includes(:home, :away, :season, :competition)
                   .next_matches

    scope = join_stats(scope)
    scope = by_competition(scope)
    scope = by_location(scope)
    scope = by_sample(scope)
    scope = apply_filters(scope)

    grouped = scope.uniq(&:id).group_by(&:competition)

    grouped.each_with_object({}) do |(competition, fixtures), result|
      fixtures_with_processed_data = fixtures.each_with_object([]) do |fixture, fixtures_result|
        fixture.home_processed_data = TeamProcessedDatum.new(fixture.read_attribute(:home_processed_data_json))
        fixture.away_processed_data = TeamProcessedDatum.new(fixture.read_attribute(:away_processed_data_json))
        fixtures_result << fixture
      end
      result[competition] = {
        fixtures: fixtures_with_processed_data,
        grouped_data: grouped_teams_processed_data_for(competition)
      }
    end
  end

  private

  def select_with_processed_data
    <<~SQL.squish
      fixtures.*,
      row_to_json(home_processed_data.*) AS home_processed_data_json,
      row_to_json(away_processed_data.*) AS away_processed_data_json
    SQL
  end

  def join_stats(scope)
    only_current = fixture_list.only_current_competition
  
    scope.joins(<<~SQL.squish)
      INNER JOIN team_processed_data AS home_processed_data
        ON home_processed_data.team_id = fixtures.home_id AND
           #{only_current ? "home_processed_data.competition_id = fixtures.competition_id" : "home_processed_data.competition_id IS NULL"}
      INNER JOIN team_processed_data AS away_processed_data
        ON away_processed_data.team_id = fixtures.away_id AND
           #{only_current ? "away_processed_data.competition_id = fixtures.competition_id" : "away_processed_data.competition_id IS NULL"}
    SQL
  end

  def by_competition(scope)
    return scope if fixture_list&.available_fixture_list_competitions.empty?
    scope.where(competition_id: fixture_list.available_fixture_list_competitions.map(&:competition_id))
  end

  def by_location(scope)
    scope.where(home_processed_data: { location: fixture_list.home_location_before_type_cast })
         .where(away_processed_data: { location: fixture_list.away_location_before_type_cast })
  end

  def by_sample(scope)
    scope.where(home_processed_data: { sample: fixture_list.sample_before_type_cast })
         .where(away_processed_data: { sample: fixture_list.sample_before_type_cast })
  end

  def apply_filters(scope)
    fixture_list.preload_data_fields!.each do |field|
      next if field.filters.empty?

      field.filters.each do |filter|
        next if filter.empty?

        aggregation, location_filters = filter
        json_field = field.data_field.statistic? ? "stats" : "facts"

        scope = apply_aggregated_filter(
          scope: scope,
          json_field: json_field,
          data_field_code: field.data_field.code,
          aggregation: aggregation,
          location_filters: location_filters
        )
      end
    end

    scope
  end

  def apply_aggregated_filter(scope:, json_field:, data_field_code:, aggregation:, location_filters:)
    %w[home away].each do |location|
      from_value = location_filters.dig(location, "from") || 0
      to_value   = location_filters.dig(location, "to")   || 10000

      scope = scope.where(<<~SQL.squish, field: data_field_code, agg: aggregation, from: from_value.to_f, to: to_value.to_f)
        (#{location}_processed_data.#{json_field} -> :field ->> :agg)::NUMERIC BETWEEN :from AND :to
      SQL
    end

    scope
  end

  def grouped_teams_processed_data_for(competition)
    GroupedTeamsProcessedDatum
      .where(competition_id: competition.id)
      .by_sample(fixture_list.sample_before_type_cast)
      .yield_self do |scope|
        {
          home: scope.find { |d| d.location == "home" },
          away: scope.find { |d| d.location == "away" }
        }
      end
  end
end