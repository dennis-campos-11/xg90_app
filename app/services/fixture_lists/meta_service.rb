class FixtureLists::MetaService
  def call
    {
      home_locations: FixtureList.enum_options(:home_location),
      away_locations: FixtureList.enum_options(:away_location),
      samples: FixtureList.enum_options(:sample),
      data_fields: data_field_options,
      competitions: Competition.select(:id, :name)
    }
  end

  private

  def data_field_options
    DataField.all.map do |df|
      {
        id: df.id,
        code: df.code,
        field_type: df.field_type,
        half_type: df.half_type,
        settings: df.settings
      }
    end
  end
end