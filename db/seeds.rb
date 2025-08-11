country = Country.find_or_create_by(external_ws_id: 1) do |c|
  c.name = 'Spain'
end

country2 = Country.find_or_create_by(external_ws_id: 2) do |c|
  c.name = 'England'
end

country3 = Country.find_or_create_by(external_ws_id: 3) do |c|
  c.name = 'Costa Rica'
end

competition = Competition.find_or_create_by(external_ws_id: 1) do |c|
  c.name = 'La Liga'
  c.country_id = country.id
end

Competition.find_or_create_by(external_ws_id: 2) do |c|
  c.name = 'Premier League'
  c.country_id = country2.id
end

Competition.find_or_create_by(external_ws_id: 3) do |c|
  c.name = 'Liga Promerica'
  c.country_id = country3.id
end

season = Season.find_or_create_by(external_ws_id: 1) do |s|
  s.name = '2024/2025'
  s.index = 0
  s.competition_id = competition.id
end

[
  { name: "Alavés", short_name: "ALA", primary_color: "#0761af", text_color: "#fff" },
  { name: "Athletic Club", short_name: "ATH", primary_color: "#ee2523", text_color: "#fff" },
  { name: "Atlético de Madrid", short_name: "ATM", primary_color: "#CB3524", text_color: "#fff" },
  { name: "FC Barcelona", short_name: "FCB", primary_color: "#a50044", text_color: "#fff" },
  { name: "Celta de Vigo", short_name: "CEL", primary_color: "#8ac3ee", text_color: "#000" },
  { name: "RCD Espanyol", short_name: "ESP", primary_color: "#007fc8", text_color: "#fff" },
  { name: "Getafe CF", short_name: "GET", primary_color: "#005999", text_color: "#fff" },
  { name: "Girona FC", short_name: "GIR", primary_color: "#d00424", text_color: "#fff" },
  { name: "UD Las Palmas", short_name: "LPA", primary_color: "#f7e603", text_color: "#000" },
  { name: "CD Leganés", short_name: "LEG", primary_color: "#0c1f6e", text_color: "#fff" },
  { name: "RCD Mallorca", short_name: "MLL", primary_color: "#E20613", text_color: "#fff" },
  { name: "CA Osasuna", short_name: "OSA", primary_color: "#0a346f", text_color: "#fff" },
  { name: "Rayo Vallecano", short_name: "RAY", primary_color: "#e43029", text_color: "#fff" },
  { name: "Real Betis", short_name: "BET", primary_color: "#0BB363", text_color: "#fff" },
  { name: "Real Madrid", short_name: "RMA", primary_color: "#00529F", text_color: "#fff" },
  { name: "Real Sociedad", short_name: "RSO", primary_color: "#0067b1", text_color: "#fff" },
  { name: "Sevilla FC", short_name: "SEV", primary_color: "#f43333", text_color: "#fff" },
  { name: "Valencia CF", short_name: "VAL", primary_color: "#EE3524", text_color: "#fff" },
  { name: "Real Valladolid", short_name: "VLL", primary_color: "#921b88", text_color: "#fff" },
  { name: "Villarreal CF", short_name: "VIL", primary_color: "#ffe667", text_color: "#000" },
].each.with_index(1) do |team, index|
  team = Team.find_or_create_by(external_ws_id: index) do |t|
    t.name = team[:name]
    t.short_name = team[:short_name]
    t.primary_color = team[:primary_color]
    t.text_color = team[:text_color]
  end

  SeasonTeam.find_or_create_by(team_id: team.id, season_id: season.id)
end

def fake_stats(half_type)
  divider = half_type == 'ft' ? 1 : 2

  {
    goal_kick: rand(0..19),
    throw_in: rand(0..10),
    throw_in_success: rand(0..10),
    corner_with_shot: rand(0..3),
    deep_completed_cross: rand(0..5),
    ball_delivery_to_penalty_area: rand(0..10),
    controlled_penalty_area_entry: rand(0..10),
    cross_to_penalty_area: rand(0..10),
    deep_completed_pass: rand(0..10),
    touch_in_box: rand(0..20),
    penalty_goal: rand(0..0),
    shot_after_free_kick: rand(0..3),
    clearance: rand(0..10),
    conceded_goal: rand(0..3),
    long_pass: rand(0..10),
    long_pass_success: rand(0..10),
    shot_against: rand(0..10),
    shot_against_success: rand(0..10),
    shot_from_outside_area: rand(0..5),
    shot_from_outside_area_success: rand(0..5),
    tackle: rand(0..10),
    tackle_success: rand(0..10),
    corner: rand(0..7),
    loss: rand(0..3),
    recovery: rand(0..5),
    duel: rand(0..10),
    duel_success: rand(0..5),
    goal: rand(0..4),
    pass: rand(100..300),
    pass_success: rand(50..250),
    shot: rand(0..10),
    shot_success: rand(0..7),
    free_kick: rand(0..5),
    penalty: rand(0..1),
    cross: rand(0..10),
    cross_success: rand(0..7),
    offensive_duel: rand(0..10),
    offensive_duel_success: rand(0..6),
    defensive_duel: rand(0..10),
    defensive_duel_success: rand(0..6),
    aerial_duel: rand(0..10),
    aerial_duel_success: rand(0..6),
    offside: rand(0..3),
    interception: rand(0..3),
    foul: rand(0..12),
    yellow_card: rand(0..5),
    red_card: rand(0..0),
    forward_pass: rand(0..100),
    forward_pass_success: rand(0..100),
    back_pass: rand(0..150),
    back_pass_success: rand(0..150),
    vertical_pass: rand(0..100),
    vertical_pass_success: rand(0..10),
    pass_to_final_third: rand(0..20),
    pass_to_final_third_success: rand(0..20),
    progressive_pass: rand(0..10),
    progressive_pass_success: rand(0..10),
    smart_pass: rand(0..10),
    smart_pass_success: rand(0..10),
    average_pass_length: rand(0..10),
    average_shot_distance: rand(0..10),
    xg_shot: rand(0..6.1),
    ppda: rand(0..3.1),
    possession: rand(0..60),
    positional_attacks: rand(0..10),
    positional_attacks_with_shot: rand(0..10),
    set_pieces: rand(0..10),
    set_pieces_with_shot: rand(0..10),
    counterattacks: rand(0..5),
    counterattacks_with_shot: rand(0..5),
    passes_per_possession_minute: rand(0..10),
    passes_per_possession_count: rand(0..10),
    recovery_low: rand(0..10),
    loss_low: rand(0..10),
    recovery_medium: rand(0..10),
    loss_medium: rand(0..10),
    recovery_high: rand(0..10),
    loss_high: rand(0..10),
    minutes_on_field: 96
  }.transform_keys{ |k| "#{k}_#{half_type}" }
  .transform_values { |v| (v / divider.to_f).floor }
end

(1..5).each do |year_index|
  Team.pluck(:id).permutation(2).to_a.each.with_index(1) do |(home_id, away_id), index|
    fixture = Fixture.find_or_create_by(external_ws_id: index * year_index) do |f|
      starting_at = (year_index.year.ago + away_id.week)
      f.home_id = home_id
      f.away_id = away_id
      f.competition_id = competition.id
      f.season_id = season.id
      f.starting_at = starting_at
      f.status = 1
      f.home_stats = fake_stats("ft").merge(fake_stats("1h")).merge(fake_stats("2h"))
      f.away_stats = fake_stats("ft").merge(fake_stats("1h")).merge(fake_stats("2h"))
    end
  end
end

next_matches = [ 
  { home_id: 1, away_id: 2 }, 
  { home_id: 3, away_id: 4 }, 
  { home_id: 5, away_id: 6 },
  { home_id: 7, away_id: 8 },
  { home_id: 9, away_id: 10 },
  { home_id: 11, away_id: 12 },
  { home_id: 13, away_id: 14 },
  { home_id: 15, away_id: 16 },
  { home_id: 17, away_id: 18 },
  { home_id: 19, away_id: 20 },
]
next_matches.each do |next_match|
  Fixture.create(
    home_id: next_match[:home_id],
    away_id: next_match[:away_id],
    competition_id: competition.id,
    season_id: season.id,
    starting_at: Time.now + 2.days,
    status: 0
  )
end

[
  "goal_kick", "throw_in", "throw_in_success", "corner_with_shot", "deep_completed_cross",
  "ball_delivery_to_penalty_area", "controlled_penalty_area_entry", "cross_to_penalty_area",
  "deep_completed_pass", "touch_in_box", "penalty_goal", "shot_after_free_kick", "clearance",
  "conceded_goal", "long_pass", "long_pass_success", "shot_against", "shot_against_success",
  "shot_from_outside_area", "shot_from_outside_area_success", "tackle", "tackle_success",
  "corner", "loss", "recovery", "duel", "duel_success", "goal", "pass", "pass_success",
  "shot", "shot_success", "free_kick", "penalty", "cross", "cross_success", "offensive_duel",
  "offensive_duel_success", "defensive_duel", "defensive_duel_success", "aerial_duel",
  "aerial_duel_success", "offside", "interception", "foul", "yellow_card", "red_card",
  "forward_pass", "forward_pass_success", "back_pass", "back_pass_success", "vertical_pass",
  "vertical_pass_success", "pass_to_final_third", "pass_to_final_third_success",
  "progressive_pass", "progressive_pass_success", "smart_pass", "smart_pass_success",
  "average_pass_length", "average_shot_distance", "xg_shot", "ppda", "possession",
  "positional_attacks", "positional_attacks_with_shot", "set_pieces", "set_pieces_with_shot",
  "counterattacks", "counterattacks_with_shot", "passes_per_possession_minute",
  "passes_per_possession_count", "recovery_low", "loss_low", "recovery_medium",
  "loss_medium", "recovery_high", "loss_high", "minutes_on_field"
].each do |stat|
  ['ft', '1h', '2h'].each.with_index(1) do |half_type, index|
    DataField.create({
                      code: "#{stat}_#{half_type}",
                      field_type: 1,
                      half_type: index,
                      settings: { 
                                  average: { min:0, max:90, step:0.01 }, 
                                  average_by_period: { min:0, max:90, step:0.01 }, 
                      }
                    })
  end
end

facts = [
  'win', 'draw', 'loss', 'no_win', 'no_draw', 'no_loss',
  'scoring_goal', 'conceded_a_goal', 'failed_to_score', 'clean_sheet',
  'both_teams_score', 'both_teams_do_not_score', 'win_to_nil',
  'win_and_both_teams_score', 'loss_to_nil', 'loss_and_both_teams_score',
  'total_goals_over_0_5', 'total_goals_over_1_5', 'total_goals_over_2_5', 
  'total_goals_over_3_5', 'total_goals_under_0_5', 'total_goals_under_1_5',
  'total_goals_under_2_5', 'total_goals_under_3_5', 'team_goals_over_0_5',
  'team_goals_over_1_5', 'team_goals_over_2_5', 'team_goals_over_3_5',
  'team_goals_under_0_5', 'team_goals_under_1_5', 'team_goals_under_2_5',
  'team_goals_under_3_5', 'opponent_goals_over_0_5', 'opponent_goals_over_1_5',
  'opponent_goals_over_2_5', 'opponent_goals_over_3_5', 'opponent_goals_under_0_5',
  'opponent_goals_under_1_5', 'opponent_goals_under_2_5', 'opponent_goals_under_3_5',
  'win_and_total_goals_over_1_5', 'win_and_total_goals_over_2_5', 'win_and_total_goals_over_3_5',
  'win_and_total_goals_under_1_5', 'win_and_total_goals_under_2_5', 'win_and_total_goals_under_3_5',
  'draw_and_total_goals_over_1_5', 'draw_and_total_goals_over_2_5', 'draw_and_total_goals_over_3_5',
  'draw_and_total_goals_under_1_5', 'draw_and_total_goals_under_2_5', 'draw_and_total_goals_under_3_5',
  'loss_and_total_goals_over_1_5', 'loss_and_total_goals_over_2_5', 'loss_and_total_goals_over_3_5',
  'loss_and_total_goals_under_1_5', 'loss_and_total_goals_under_2_5', 'loss_and_total_goals_under_3_5',
  'win_by_2_goals_or_more', 'win_by_3_goals_or_more', 'loss_by_2_goals_or_more', 'loss_by_3_goals_or_more',
  'win_corners', 'draw_corners', 'loss_corners', 'total_corners_under_1_5', 'total_corners_under_2_5',
  'total_corners_under_3_5', 'total_corners_under_4_5', 'total_corners_under_5_5', 'total_corners_under_8_5',
  'total_corners_under_9_5', 'total_corners_under_10_5', 'total_corners_under_11_5', 'total_corners_under_12_5',
  'total_corners_over_1_5', 'total_corners_over_2_5', 'total_corners_over_3_5', 'total_corners_over_4_5',
  'total_corners_over_5_5', 'total_corners_over_8_5', 'total_corners_over_9_5', 'total_corners_over_10_5',
  'total_corners_over_11_5', 'total_corners_over_12_5', 'team_corners_under_1_5', 'team_corners_under_2_5',
  'team_corners_under_3_5', 'team_corners_under_4_5', 'team_corners_under_5_5', 'team_corners_under_6_5',
  'team_corners_under_7_5', 'team_corners_under_8_5', 'team_corners_over_1_5', 'team_corners_over_2_5',
  'team_corners_over_3_5', 'team_corners_over_4_5', 'team_corners_over_5_5', 'team_corners_over_6_5',
  'team_corners_over_7_5', 'team_corners_over_8_5', 'opponent_corners_under_1_5', 'opponent_corners_under_2_5',
  'opponent_corners_under_3_5', 'opponent_corners_under_4_5', 'opponent_corners_under_5_5', 'opponent_corners_under_6_5',
  'opponent_corners_under_7_5', 'opponent_corners_under_8_5', 'opponent_corners_over_1_5', 'opponent_corners_over_2_5',
  'opponent_corners_over_3_5', 'opponent_corners_over_4_5', 'opponent_corners_over_5_5', 'opponent_corners_over_6_5',
  'opponent_corners_over_7_5', 'opponent_corners_over_8_5', 'total_yellow_cards_under_2_5', 'total_yellow_cards_under_3_5',
  'total_yellow_cards_under_4_5', 'total_yellow_cards_under_5_5', 'total_yellow_cards_over_2_5', 'total_yellow_cards_over_3_5',
  'total_yellow_cards_over_4_5', 'total_yellow_cards_over_5_5', 'team_yellow_cards_under_0_5', 'team_yellow_cards_under_1_5',
  'team_yellow_cards_under_2_5', 'team_yellow_cards_under_3_5', 'team_yellow_cards_over_0_5', 'team_yellow_cards_over_1_5',
  'team_yellow_cards_over_2_5', 'team_yellow_cards_over_3_5', 'opponent_yellow_cards_under_0_5', 'opponent_yellow_cards_under_1_5',
  'opponent_yellow_cards_under_2_5', 'opponent_yellow_cards_under_3_5', 'opponent_yellow_cards_over_0_5', 'opponent_yellow_cards_over_1_5',
  'opponent_yellow_cards_over_2_5', 'opponent_yellow_cards_over_3_5', 'total_red_cards_under_0_5', 'total_red_cards_over_0_5'
].map do |fact|
  ['ft', '1h', '2h'].each.with_index(1) do |half_type, index|
    DataField.create({
                      code: "#{fact}_#{half_type}",
                      field_type: 2,
                      half_type: index,
                      settings: {
                        percentage: { min: 0, max: 100, step: 1 },
                        streak: { min: 0, max: 50, step: 1 }
                      }
                    })
  end
end

Fixture.where(status: 1).each do |f|
  CalculateFacts.new(f).process
end

fixture_list = FixtureList.create(total_matches: 10, home_location: 1, away_location: 2, only_current_competition: true)
FixtureListField.create(fixture_list_id: fixture_list.id, data_field_id: 1, filters: [{ average: { home: { from: 0, to: 100 } } }])
FixtureListField.create(fixture_list_id: fixture_list.id, data_field_id: 2, filters: [{ average: { home: { from: 0, to: 100 } } }])
FixtureListField.create(fixture_list_id: fixture_list.id, data_field_id: 3, filters: [{ average: { home: { from: 0, to: 100 } } }])

# Team.all.each do |team|
#   CalculateTeamProcessedData.new(team, Competition.first).process
# end