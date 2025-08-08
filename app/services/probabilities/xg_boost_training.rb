class Probabilities::XgBoostTraining
  attr_accessor :probabilities_markets

  MODEL_PARAMS = {
    max_depth: 5,
    eta: 0.1,
    subsample: 0.8,
    colsample_bytree: 0.8,
    objective: "multi:softprob",
    lambda: 1.0,
    alpha: 0.1,
    min_child_weight: 10,
    eval_metric: "mlogloss"
  }
  
  NUM_BOOST_ROUND = 1000
  EARLY_STOPPING_ROUNDS = 50

  def initialize
    @probabilities_markets = YAML.load_file(Rails.root.join('config', 'data', 'probabilities_markets.yml'), symbolize_names: true)
  end

  def process
    probabilities_markets.each do |probability_markets|
      data_fields = DataField.statistic.send(probability_markets[:half_type])

      probability_markets[:markets].each do |market|
        market.each do |market_name, market_options|
          features, labels = fetch_training_data(data_fields, market_name, market_options)
          training_model(features, labels, market_options)
        end
      end
    end
  end

  private

  def historical_fixtures
    Fixture.where("starting_at >= ? AND status = 1", Time.now - 3.years)
  end

  def fetch_training_data(data_fields, market_name, market_options)
    training_features = []
    training_labels = Hash.new { |h, k| h[k] = [] }

    historical_fixtures.find_each do |fixture|
      row = build_feature_row(fixture, data_fields)
      training_features << row

      training_labels[market_name] << extract_label(fixture, market_options)
    end

    [training_features.map(&:values), training_labels]
  end

  def build_feature_row(fixture, data_fields)
    data_fields.each_with_object({}) do |data_field, feature|
      key = data_field.code
      feature[:"home_#{data_field.code}"] = fixture.home_stats[key] if fixture.home_stats.key?(key)
      feature[:"away_#{data_field.code}"] = fixture.away_stats[key] if fixture.away_stats.key?(key)
    end
  end

  def extract_label(fixture, market_options)
    market_options.find { |key, value| key if fixture.home_facts[value[:stat_key]] == 1 }&.first
  end

  def xgboost_params(num_class)
    MODEL_PARAMS.merge(num_class: num_class)
  end

  def training_model(features, labels, market_options)
    labels.each do |market_name, label_values|
      split_index = (features.size * 0.8).to_i
      train_features = features[0...split_index]
      train_labels   = label_values[0...split_index]
      valid_features = features[split_index..]
      valid_labels   = label_values[split_index..]
  
      dtrain = XGBoost::DMatrix.new(train_features, label: train_labels)
      dvalid = XGBoost::DMatrix.new(valid_features, label: valid_labels)

      model = XGBoost.train(
        xgboost_params(market_options.uniq.size),
        dtrain,
        num_boost_round: NUM_BOOST_ROUND,
        evals: [[dtrain, "train"], [dvalid, "eval"]],
        early_stopping_rounds: EARLY_STOPPING_ROUNDS
      )
      model.save_model(model_path(market_name))
    end
  end

  def model_path(market_name)
    Rails.root.join("lib/xgb/models/#{market_name}.json").to_s
  end
end
