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
  json.common_name fixture.home.common_name
  json.short_name fixture.home.short_name
end

json.away do
  json.id fixture.away.id
  json.name fixture.away.name
  json.common_name fixture.away.common_name
  json.short_name fixture.away.short_name
end

json.home_processed_stats fixture.home_processed_stats
json.away_processed_stats fixture.away_processed_stats
json.home_processed_facts fixture.home_processed_facts
json.away_processed_facts fixture.away_processed_facts
