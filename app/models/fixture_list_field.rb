class FixtureListField < ApplicationRecord
  belongs_to :fixture_list
  belongs_to :data_field
end
