json.id fixture_list.id
json.name fixture_list.name
json.total_matches fixture_list.total_matches
json.season_index fixture_list.season_index
json.home_location fixture_list.home_location_before_type_cast
json.away_location fixture_list.away_location_before_type_cast
json.sort fixture_list.sort
json.settings fixture_list.settings

json.fixture_list_competitions fixture_list.fixture_list_competitions do |lc|
  json.id lc.id
  json.competition do
    json.id lc.competition.id
    json.name lc.competition.name
  end
  json.competition_id lc.competition_id
  json._destroy lc._destroy
end

json.fixture_list_fields fixture_list.fixture_list_fields do |lf|
  json.id lf.id
  json.data_field do
    json.id lf.data_field.id
    json.code lf.data_field.code
    json.field_type lf.data_field.field_type
    json.settings lf.data_field.settings
  end
  json.data_field_id lf.data_field_id
  json.filters lf.filters
  json.index lf.index
  json._destroy lf._destroy
end
