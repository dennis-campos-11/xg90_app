class FixtureLists::MetaService
  def call
    {
      home_locations: FixtureList.enum_options(:home_location),
      away_locations: FixtureList.enum_options(:away_location),
      data_fields: data_field_options,
      competitions: Competition.select(:id, :name),
      season_indexes: seasons_options,
      dates: dates_options
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

  def dates_options
    dates = I18n.t("activerecord.attributes.FixtureList.dates")

    array = dates.map do |key, value|
      { id: key.to_i, value: value }
    end
  end

  def seasons_options
    season_indexes = I18n.t("activerecord.attributes.FixtureList.season_indexes")

    array = season_indexes.map do |key, value|
      { id: key.to_i, value: value }
    end
  end
end