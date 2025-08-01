class CalculateGroupedTeamsProcessedData
  def initialize(competition, only_current_competition: false)
    @competition = competition
    @only_current_competition = only_current_competition
  end

  def process
    team_ids = @competition.current_season.teams.pluck(:id)
    ::GroupedTeamsProcessedDatum.locations.each do |location_key, location_value|
      ::GroupedTeamsProcessedDatum.samples.each do |sample_key, sample_value|
        teams_processed_datum = TeamProcessedDatum.where(
          location: location_value,
          sample: sample_value,
          team_id: team_ids,
          competition_id: @only_current_competition ? @competition.id : nil
        )

        stats = calculate_stats(teams_processed_datum)
        facts = calculate_facts(teams_processed_datum)

        grouped_team_processed_data = ::GroupedTeamsProcessedDatum.find_or_initialize_by(
          competition_id: @competition.id,
          only_current_competition: @only_current_competition,
          location: location_value,
          sample: sample_value
        )
        
        grouped_team_processed_data.stats = stats
        grouped_team_processed_data.facts = facts
        grouped_team_processed_data.save!
      end
    end
  end

  def calculate_nested_averages(team_processed_data, field:, keys_to_average:)
    data_array = team_processed_data.map(&field)
  
    merged = {}
  
    data_array.each do |data|
      data.each do |key, values|
        merged[key] ||= Hash.new { |h, k| h[k] = [] }
        keys_to_average.each do |subkey|
          merged[key][subkey] << values[subkey].to_f if values[subkey]
        end
      end
    end
  
    merged.transform_values do |value_hash|
      value_hash.transform_values do |values|
        values.sum / values.size
      end
    end
  end

  def calculate_stats(team_processed_data)
    calculate_nested_averages(
      team_processed_data,
      field: :stats,
      keys_to_average: ["average", "average_by_period"]
    )
  end
  
  def calculate_facts(team_processed_data)
    calculate_nested_averages(
      team_processed_data,
      field: :facts,
      keys_to_average: ["percentage"]
    )
  end  
  
end