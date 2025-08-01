json.id fixture_list.id
json.name fixture_list.name
json.sample fixture_list.sample_before_type_cast
json.home_location fixture_list.home_location_before_type_cast
json.away_location fixture_list.away_location_before_type_cast
json.only_current_competition fixture_list.only_current_competition
json.show_variance_against_competition fixture_list.show_variance_against_competition

json.fixture_list_competitions fixture_list.fixture_list_competitions do |flc|
  json.id flc.id
  json.competition do
    json.id flc.competition.id
    json.name flc.competition.name
  end
end

json.fixture_list_fields fixture_list.fixture_list_fields do |field|
  json.id field.id
  json.data_field do
    json.id field.data_field.id
    json.code field.data_field.code
    json.field_type field.data_field.field_type
    json.settings field.data_field.settings
  end
  json.filters field.filters
  json.index field.index
  json._destroy field._destroy
end
