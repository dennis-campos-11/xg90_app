class FixtureTeamProcessedDatum
  attr_accessor :fixture_list

  def initialize(fixture_list)
    @fixture_list = fixture_list
  end

  def get_data
    params = fixture_list.full_params
    sanitized_json = ActiveRecord::Base.connection.quote(params.to_json)
    sql = "SELECT * FROM process_fixture_list_data(#{sanitized_json}::jsonb)"
    result = ActiveRecord::Base.connection.exec_query(sql)
    fixtures_with_mapped_stats(result)
  end

  private

  def fixtures_with_mapped_stats(result)
    location_mapping = { 1 => 'home', 2 => 'away' }

    fixture_ids = result.rows.map { |row| row[result.columns.index("fixture_id")] }.uniq
    fixtures = Fixture.includes(:home, :away, :competition, :season).where(id: fixture_ids).index_by(&:id)
    stats_per_fixture = result.to_a.group_by { |row| row["fixture_id"] }

    fixtures.map do |id, fixture|
      stats_for_fixture = stats_per_fixture[id] || []
      stats_by_location = stats_for_fixture.group_by { |r| r["team_location"].to_i }

      location_mapping.each do |location_id, location_name|
        next unless stats_by_location[location_id]

        stats = stats_by_location[location_id]

        define_stats_hash = ->(json_array) {
          parsed = json_array.map { |r| JSON.parse(r) rescue r }
          parsed.reduce({}) do |acc, h|
            key = h.delete("field_code") || h.delete(:field_code)
            acc[key] = h
            acc
          end
        }

        fixture.define_singleton_method("#{location_name}_processed_stats") do
          json_array = stats.flat_map { |r| r["processed_stats"] ? JSON.parse(r["processed_stats"]) : [] }
          define_stats_hash.call(json_array)
        end

        fixture.define_singleton_method("#{location_name}_processed_facts") do
          json_array = stats.flat_map { |r| r["processed_facts"] ? JSON.parse(r["processed_facts"]) : [] }
          define_stats_hash.call(json_array)
        end
      end

      fixture
    end
  end
end