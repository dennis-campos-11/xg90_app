# db/seeds.rb

def create_country(id, name)
  Country.find_or_create_by(external_ws_id: id) { |c| c.name = name }
end

def create_competition(id, name, country)
  Competition.find_or_create_by(external_ws_id: id) do |c|
    c.name = name
    c.country = country
  end
end

def create_season(id, name, competition, index: 0)
  Season.find_or_create_by(external_ws_id: id) do |s|
    s.name = name
    s.index = index
    s.competition = competition
  end
end

def create_teams(teams, season, offset:)
  teams.each.with_index(offset) do |team_data, index|
    team = Team.find_or_create_by(external_ws_id: index) do |t|
      t.name          = team_data[:name]
      t.short_name    = team_data[:short_name]
      t.common_name   = team_data[:common_name]
      t.primary_color = team_data[:primary_color]
      t.text_color    = team_data[:text_color]
    end

    SeasonTeam.find_or_create_by(team: team, season: season)
  end
end

# =======================
# DATA DEFINITIONS
# =======================

countries = {
  spain:      { id: 1, name: "Spain" },
  england:    { id: 2, name: "England" },
  costa_rica: { id: 3, name: "Costa Rica" }
}

competitions = {
  la_liga:          { id: 1, name: "La Liga", country: :spain },
  premier_league:   { id: 2, name: "Premier League", country: :england },
  primera_division: { id: 3, name: "Liga Promerica", country: :costa_rica }
}

seasons = [
  { id: 1, competition: :la_liga },
  { id: 2, competition: :premier_league },
  { id: 3, competition: :primera_division }
]

teams_data = {
  la_liga: [
    { name: "Deportivo Alavés", common_name: "Alavés", short_name: "ALA", primary_color: "#0761af", text_color: "#fff" },
    { name: "Athletic Club de Bilbao", common_name: "Athletic Club", short_name: "ATH", primary_color: "#ee2523", text_color: "#fff" },
    { name: "Club Atlético de Madrid", common_name: "Atlético de Madrid", short_name: "ATM", primary_color: "#CB3524", text_color: "#fff" },
    { name: "Futbol Club Barcelona", common_name: "Barcelona", short_name: "FCB", primary_color: "#a50044", text_color: "#fff" },
    { name: "Real Club Celta de Vigo", common_name: "Celta de Vigo", short_name: "CEL", primary_color: "#8ac3ee", text_color: "#000" },
    { name: "Reial Club Deportiu Espanyol", common_name: "Espanyol", short_name: "ESP", primary_color: "#007fc8", text_color: "#fff" },
    { name: "Getafe Club de Fútbol", common_name: "Getafe", short_name: "GET", primary_color: "#005999", text_color: "#fff" },
    { name: "Girona Futbol Club", common_name: "Girona", short_name: "GIR", primary_color: "#d00424", text_color: "#fff" },
    { name: "Unión Deportiva Las Palmas", common_name: "Las Palmas", short_name: "LPA", primary_color: "#f7e603", text_color: "#000" },
    { name: "Club Deportivo Leganés", common_name: "Leganés", short_name: "LEG", primary_color: "#0c1f6e", text_color: "#fff" },
    { name: "Real Club Deportivo Mallorca", common_name: "Mallorca", short_name: "MLL", primary_color: "#E20613", text_color: "#fff" },
    { name: "Club Atlético Osasuna", common_name: "Osasuna", short_name: "OSA", primary_color: "#0a346f", text_color: "#fff" },
    { name: "Rayo Vallecano de Madrid", common_name: "Rayo Vallecano", short_name: "RAY", primary_color: "#e43029", text_color: "#fff" },
    { name: "Real Betis Balompié", common_name: "Real Betis", short_name: "BET", primary_color: "#0BB363", text_color: "#fff" },
    { name: "Real Madrid Club de Fútbol", common_name: "Real Madrid", short_name: "RMA", primary_color: "#00529F", text_color: "#fff" },
    { name: "Real Sociedad de Fútbol", common_name: "Real Sociedad", short_name: "RSO", primary_color: "#0067b1", text_color: "#fff" },
    { name: "Sevilla Fútbol Club", common_name: "Sevilla", short_name: "SEV", primary_color: "#f43333", text_color: "#fff" },
    { name: "Valencia Club de Fútbol", common_name: "Valencia", short_name: "VAL", primary_color: "#EE3524", text_color: "#fff" },
    { name: "Real Valladolid Club de Fútbol", common_name: "Real Valladolid", short_name: "VLL", primary_color: "#921b88", text_color: "#fff" },
    { name: "Villarreal Club de Fútbol", common_name: "Villarreal", short_name: "VIL", primary_color: "#ffe667", text_color: "#000" }
  ],
  premier_league: [
    { name: "Arsenal Football Club", common_name: "Arsenal", short_name: "ARS", primary_color: "#EF0107", text_color: "#fff" },
    { name: "Aston Villa Football Club", common_name: "Aston Villa", short_name: "AVL", primary_color: "#95BFE5", text_color: "#7A003C" },
    { name: "AFC Bournemouth", common_name: "Bournemouth", short_name: "BOU", primary_color: "#DA291C", text_color: "#000" },
    { name: "Brentford Football Club", common_name: "Brentford", short_name: "BRE", primary_color: "#E30613", text_color: "#fff" },
    { name: "Brighton & Hove Albion Football Club", common_name: "Brighton", short_name: "BHA", primary_color: "#0057B8", text_color: "#fff" },
    { name: "Burnley Football Club", common_name: "Burnley", short_name: "BUR", primary_color: "#6C1D45", text_color: "#f1f1f1" },
    { name: "Chelsea Football Club", common_name: "Chelsea", short_name: "CHE", primary_color: "#034694", text_color: "#fff" },
    { name: "Crystal Palace Football Club", common_name: "Crystal Palace", short_name: "CRY", primary_color: "#1B458F", text_color: "#fff" },
    { name: "Everton Football Club", common_name: "Everton", short_name: "EVE", primary_color: "#003399", text_color: "#fff" },
    { name: "Fulham Football Club", common_name: "Fulham", short_name: "FUL", primary_color: "#000000", text_color: "#fff" },
    { name: "Leeds United Football Club", common_name: "Leeds United", short_name: "LEE", primary_color: "#FFCD00", text_color: "#1D428A" },
    { name: "Liverpool Football Club", common_name: "Liverpool", short_name: "LIV", primary_color: "#C8102E", text_color: "#fff" },
    { name: "Manchester City Football Club", common_name: "Manchester City", short_name: "MCI", primary_color: "#6CABDD", text_color: "#1C2C5B" },
    { name: "Manchester United Football Club", common_name: "Manchester United", short_name: "MUN", primary_color: "#DA291C", text_color: "#fff" },
    { name: "Newcastle United Football Club", common_name: "Newcastle", short_name: "NEW", primary_color: "#241F20", text_color: "#fff" },
    { name: "Nottingham Forest Football Club", common_name: "Nottingham Forest", short_name: "NFO", primary_color: "#DD0000", text_color: "#fff" },
    { name: "Sunderland Association Football Club", common_name: "Sunderland", short_name: "SUN", primary_color: "#E41B17", text_color: "#fff" },
    { name: "Tottenham Hotspur Football Club", common_name: "Tottenham Hotspur", short_name: "TOT", primary_color: "#132257", text_color: "#fff" },
    { name: "West Ham United Football Club", common_name: "West Ham", short_name: "WHU", primary_color: "#7A263A", text_color: "#F3D459" },
    { name: "Wolverhampton Wanderers Football Club", common_name: "Wolverhampton", short_name: "WOL", primary_color: "#FDB913", text_color: "#000" }
  ],
  primera_division: [
    { name: "Club Sport Cartaginés", common_name: "Cartaginés", short_name: "CSC", primary_color: "#005BAA", text_color: "#fff" },
    { name: "Liga Deportiva Alajuelense", common_name: "Alajuelense", short_name: "LDA", primary_color: "#C8102E", text_color: "#fff" },
    { name: "Club Sport Herediano", common_name: "Herediano", short_name: "CSH", primary_color: "#FFCC00", text_color: "#000" },
    { name: "Deportivo Saprissa", common_name: "Saprissa", short_name: "SAP", primary_color: "#522398", text_color: "#fff" },
    { name: "Guadalupe Fútbol Club", common_name: "Guadalupe", short_name: "GUA", primary_color: "#007C41", text_color: "#fff" },
    { name: "Asociación Deportiva San Carlos", common_name: "San Carlos", short_name: "SCA", primary_color: "#005EB8", text_color: "#fff" },
    { name: "Municipal Liberia", common_name: "Liberia", short_name: "LIB", primary_color: "#005BBB", text_color: "#fff" },
    { name: "Municipal Pérez Zeledón", common_name: "Pérez Zeledón", short_name: "MPZ", primary_color: "#770000", text_color: "#fff" },
    { name: "Puntarenas Fútbol Club", common_name: "Puntarenas", short_name: "PFC", primary_color: "#E62020", text_color: "#fff" },
    { name: "Sporting Football Club", common_name: "Sporting", short_name: "SFC", primary_color: "#E02828", text_color: "#fff" }
  ]
}

# =======================
# CREATION FLOW
# =======================

created_countries = countries.transform_values { |c| create_country(c[:id], c[:name]) }
created_competitions = competitions.transform_values { |c| create_competition(c[:id], c[:name], created_countries[c[:country]]) }
created_seasons = seasons.map { |s| [s[:competition], create_season(s[:id], "2024/2025", created_competitions[s[:competition]])] }.to_h

offset = 1
teams_data.each do |competition_key, teams|
  season = created_seasons[competition_key]
  create_teams(teams, season, offset: offset)
  offset = offset + teams.count + 1
end

# ==============================
# Fixtures fake stats
# ==============================
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

def create_fixtures_for_competition(competition, seasons: 5)
  seasons.times do |year_index|
    season = competition.current_season

    season.teams.pluck(:id).permutation(2).each.with_index(1) do |(home_id, away_id), idx|
      external_id = Random.rand(99999999999999)
      starting_at = (year_index + 1).years.ago + away_id.weeks

      Fixture.find_or_create_by(external_ws_id: external_id) do |f|
        f.home_id       = home_id
        f.away_id       = away_id
        f.competition   = competition
        f.season        = season
        f.starting_at   = starting_at
        f.status        = 1
        f.home_stats    = %w[ft 1h 2h].map { |p| fake_stats(p) }.reduce(:merge)
        f.away_stats    = %w[ft 1h 2h].map { |p| fake_stats(p) }.reduce(:merge)
      end
    end
  end
end

# ==============================
# Crear temporadas pasadas con fixtures simulados
# ==============================
created_competitions.values.each do |competition|
  create_fixtures_for_competition(competition, seasons: 5)
end

# ==============================
# Crear un set inicial de fixtures próximos (2 días)
# ==============================
created_competitions.each do |key, competition|
  season = created_seasons[key]
  teams = season.teams.pluck(:id)

  teams.each_slice(2).with_index do |(home_id, away_id), index|
    next unless away_id

    Fixture.find_or_create_by!(
      home_id: home_id,
      away_id: away_id,
      competition: competition,
      season: season,
      starting_at: Time.current + (index * 3).hours,
      status: 0
    )
  end
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