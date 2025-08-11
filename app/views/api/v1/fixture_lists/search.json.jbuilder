json.fixture_list do
  json.partial! 'fixture_list', fixture_list: @fixture_list
end

json.fixtures do
  json.array! @fixtures, partial: 'fixture', as: :fixture
end