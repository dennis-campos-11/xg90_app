module ProcessedDataHelper
  def round_fixture_stat_values(stats)
    return {} unless stats

    stats.transform_values do |values|
      {
        total: values['total'].to_i,
        average: values['average'].to_f.round(1),
        average_by_period: values['average_by_period'].to_f.round(1)
      }
    end
  end

  def round_fixture_fact_values(stats)
    return {} unless stats

    stats.transform_values do |values|
      {
        total: values['total'].to_i,
        streak: values['streak'].to_i,
        percentage: values['percentage'].to_i
      }
    end
  end

  def round_competition_stat_values(stats)
    return {} unless stats

    stats.transform_values do |values|
      {
        average: values['average'].to_f.round(1),
        average_by_period: values['average_by_period'].to_f.round(1)
      }
    end
  end

  def round_competition_fact_values(stats)
    return {} unless stats

    stats.transform_values do |values|
      {
        percentage: values['percentage'].to_i
      }
    end
  end
end
