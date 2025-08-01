module DefineStatsMethods
  extend ActiveSupport::Concern

  included do
    FIXTURE_STATISTICS = %i[goal corner yellow_card red_card]
    PERIODS = %i[ft 1h 2h]

    FIXTURE_STATISTICS.each do |field|
      PERIODS.each do |period|
        field_code = "#{field}_#{period}"
        define_method "home_#{field_code}" do
          home_stats["#{field_code}"]
        end

        define_method "away_#{field_code}" do
          away_stats["#{field_code}"]
        end
      end
    end
  end
end