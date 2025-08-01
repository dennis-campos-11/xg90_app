json.id fixture.id
json.starting_at fixture.starting_at
json.kick_off fixture.starting_at.strftime("%H:%M")

json.competition do
  json.id fixture.competition.id
  json.name fixture.competition.name
end

json.season do
  json.id fixture.season.id
  json.name fixture.season.name
end

json.home do
  json.id fixture.home.id
  json.name fixture.home.name
end

json.away do
  json.id fixture.away.id
  json.name fixture.away.name
end

json.home_processed_stats round_fixture_stat_values(fixture.home_processed_data.stats.slice(*allowed_stats))
json.away_processed_stats round_fixture_stat_values(fixture.away_processed_data.stats.slice(*allowed_stats))
json.home_processed_facts round_fixture_fact_values(fixture.home_processed_data.facts.slice(*allowed_facts))
json.away_processed_facts round_fixture_fact_values(fixture.away_processed_data.facts.slice(*allowed_facts))
