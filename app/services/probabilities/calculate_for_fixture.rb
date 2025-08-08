class Probabilities::CalculateForFixture
  attr_reader :fixture, :probabilities_markets

  def initialize(fixture_id)
    @probabilities_markets = YAML.load_file(Rails.root.join('config', 'data', 'probabilities_markets.yml'), symbolize_names: true)
    @fixture = Fixture.find(fixture_id)
  end

  def process
    probabilities = {}
    probabilities_markets.each do |probability_markets|
      probability_markets[:markets].each do |market|
        market.each do |market_name, options|
          features = process_half_type(probability_markets[:half_type])
          predictor_data = predictor(features, market_name, options)
          probabilities.merge!(predictor_data)
        end
      end
    end

    probabilities
  end

  private

  def predictor(features, market_name, options)
    booster = XGBoost::Booster.new(model_file: "lib/xgb/models/#{market_name}.json")
    dmatrix = XGBoost::DMatrix.new([features])
    booster_probabilities = booster.predict(dmatrix).first
    
    booster_probabilities.each_with_index.with_object({}) do |(probability, index), data|
      market = options[index]
      prediction_key = market[:probability_key] || market[:stat_key]
      data[prediction_key] = probability
    end
  end

  def process_half_type(half_type)
    data_fields = DataField.statistic.send(half_type)

    home_processed_data = TeamProcessedDatum.find_by(team_id: fixture.home_id, location: 'home', sample: 'last_15_games')
    away_processed_data = TeamProcessedDatum.find_by(team_id: fixture.away_id, location: 'away', sample: 'last_15_games')

    data_fields.flat_map do |field|
      home_avg = home_processed_data.stats.dig(field.code, 'average')
      away_avg = away_processed_data.stats.dig(field.code, 'average')
      [home_avg, away_avg].compact
    end
  end
end
