class FixtureList < ApplicationRecord
  include EnumOptions
  
  has_many :fixture_list_fields, inverse_of: :fixture_list, dependent: :destroy

  has_many :fixture_list_competitions, inverse_of: :fixture_list, dependent: :destroy
  has_many :competitions, through: :fixture_list_competitions

  accepts_nested_attributes_for :fixture_list_fields, allow_destroy: true
  accepts_nested_attributes_for :fixture_list_competitions, allow_destroy: true

  enum :home_location, { home: 1, away: 2, both: 3 }, prefix: true
  enum :away_location, { home: 1, away: 2, both: 3 }, prefix: true

  validates :name, uniqueness: true, presence: true

  def available_fixture_list_fields
    fixture_list_fields.reject(&:marked_for_destruction?)
  end

  def available_fixture_list_competitions
    fixture_list_competitions.reject(&:marked_for_destruction?)
  end

  def preload_data_fields!
    fields = available_fixture_list_fields
    return fields if fields.empty?

    data_fields = DataField.where(id: fields.map(&:data_field_id)).index_by(&:id)

    fields.each do |f|
      f.association(:data_field).target = data_fields[f.data_field_id]
    end

    fields
  end

  def full_params
    params = attributes.merge(
      "fixture_list_fields_attributes" => fixture_list_fields.map(&:attributes),
      "fixture_list_competitions_attributes" => fixture_list_competitions.map(&:attributes)
    )

    params["home_location"] = self.home_location_before_type_cast
    params["away_location"] = self.away_location_before_type_cast
    params
  end
end
