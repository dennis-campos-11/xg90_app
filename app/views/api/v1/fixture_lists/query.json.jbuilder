json.fixture_list do
  json.partial! 'fixture_list', fixture_list: @fixture_list
end

json.grouped_fixtures @grouped_fixtures do |competition, data|
  fixtures = data[:fixtures]
  grouped_data = data[:grouped_data]

  json.competition do
    json.id competition.id
    json.name competition.name
    json.country do
      json.id competition.country.id
      json.name competition.country.name
    end

    json.grouped_processed_stats do
      json.home round_competition_stat_values(grouped_data[:home].stats.slice(*@allowed_stats)) if grouped_data[:home]
      json.away round_competition_stat_values(grouped_data[:away].stats.slice(*@allowed_stats)) if grouped_data[:away]
    end

    json.grouped_processed_facts do
      json.home round_competition_fact_values(grouped_data[:home].facts.slice(*@allowed_facts)) if grouped_data[:home]
      json.away round_competition_fact_values(grouped_data[:away].facts.slice(*@allowed_facts)) if grouped_data[:away]
    end
  end

  json.fixtures fixtures do |fixture|
    json.partial! 'fixture', fixture: fixture, allowed_stats: @allowed_stats, allowed_facts: @allowed_facts
  end
end
