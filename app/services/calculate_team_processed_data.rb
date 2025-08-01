class CalculateTeamProcessedData
  def initialize(team, competition = nil)
    @team = team
    @competition = competition
  end

  def process
    ::TeamProcessedDatum.locations.each do |location_key, location_value|
      ::TeamProcessedDatum.samples.each do |sample_key, sample_value|
        fixtures = TeamFixturesQuery.new(
          team_id: @team.id,
          competition_id: @competition&.id,
          location: location_key,
          sample: sample_key
        ).call

        stats = calculate_stats(fixtures)
        facts = calculate_facts(fixtures)

        team_processed_data = ::TeamProcessedDatum.find_or_initialize_by(
          team_id: @team.id,
          competition_id: @competition&.id,
          location: location_value,
          sample: sample_value
        )
        
        team_processed_data.stats = stats
        team_processed_data.facts = facts
        team_processed_data.save!
      end
    end
  end

  private

  def calculate_stats(fixtures)
    totals = Hash.new(0)
    counts = Hash.new(0)

    fixtures.each do |fixture|
      team_stats = fixture.stats_by_team(@team)&.with_indifferent_access
      team_stats.each do |key, value|
        totals[key] += value.to_f
        counts[key] += 1
      end
    end

    totals.each_with_object({}) do |(key, total), result|
      period = extract_period(key)
      minutes_key = "minutes_on_field_#{period}"
      average = total / counts[key]
      average_by_period = total / (totals[minutes_key] / period_minutes(period))

      result[key] = {
        "total" => total,
        "average" => average,
        "average_by_period" => average_by_period
      }
    end
  end

  def calculate_facts(fixtures)
    totals = Hash.new(0)
    counts = Hash.new(0)
    streaks = Hash.new(0)
    in_active_streak = Hash.new(true)

    fixtures.each do |fixture|
      team_facts = fixture.facts_by_team(@team)&.with_indifferent_access
      team_facts.each do |key, value|
        totals[key] += value.to_f
        counts[key] += 1

        update_streak!(streaks, in_active_streak, key, value)
      end
    end

    totals.each_with_object({}) do |(key, total), result|
      result[key] = {
        "total" => total,
        "percentage" => (total / counts[key]) * 100,
        "streak" => streaks[key]
      }
    end
  end

  def update_streak!(streaks, in_active_streak, key, value)
    if in_active_streak[key]
      if value == 1
        streaks[key] += 1
      else
        in_active_streak[key] = false
      end
    end
  end

  def extract_period(key)
    key[-2..-1]
  end

  def period_minutes(period)
    case period
    when "ft" then 90
    when "1h", "2h" then 45
    else 1
    end
  end
end
