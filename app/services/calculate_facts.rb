class CalculateFacts
  attr_reader :fixture

  def initialize(fixture)
    @fixture = fixture
  end

  def process
    home_facts = process_team_facts(fixture.home)
    away_facts = process_team_facts(fixture.away, swap: true)
    fixture.update(home_facts:, away_facts:)
  end

  private
    def process_team_facts(team, swap: false)
      stats_ft = create_facts(team, period_statistics("ft", swap), "ft")
      stats_1h = create_facts(team, period_statistics("1h", swap), "1h")
      stats_2h = create_facts(team, period_statistics("2h", swap), "2h")
      stats_ft.merge(stats_1h).merge(stats_2h)
    end

    def calculate_totals(statistics)
      statistics.transform_values { |(team_stat, opponent_stat)| team_stat + opponent_stat }
    end

    def period_statistics(period, swap)
      statistics = {
        goals: fetch_statistics(period, :goal, swap),
        corners: fetch_statistics(period, :corner, swap),
        yellow_cards: fetch_statistics(period, :yellow_card, swap),
        red_cards: fetch_statistics(period, :red_card, swap)
      }
      statistics.merge!(total: calculate_totals(statistics))
    end

    def fetch_statistics(period, stat, swap)
      home_key = "home_#{stat}_#{period}".to_sym
      away_key = "away_#{stat}_#{period}".to_sym
      swap ? [fixture.send(away_key), fixture.send(home_key)] : [fixture.send(home_key), fixture.send(away_key)]
    end

    def create_facts(team, statistics, period)
      team_goals, opponent_goals = statistics[:goals]
      total_goals = statistics[:total][:goals]

      team_corners, opponent_corners = statistics[:corners]
      total_corners = statistics[:total][:goals]

      team_yellow_cards, opponent_yellow_cards = statistics[:yellow_cards]
      total_yellow_cards = statistics[:total][:goals]

      team_red_cards, opponent_red_cards = statistics[:red_cards]
      total_red_cards = statistics[:total][:goals]

      facts = {}
      # 1X2 Result
      facts['win']  = win(team_goals, opponent_goals)
      facts['draw'] = draw(team_goals, opponent_goals)
      facts['loss'] = loss(team_goals, opponent_goals)
      # Double Chance
      facts['no_win']  = no_win(team_goals, opponent_goals)
      facts['no_draw'] = no_draw(team_goals, opponent_goals)
      facts['no_loss'] = no_loss(team_goals, opponent_goals)
      # Goals
      facts['scoring_goal'] = over(team_goals, 0.5)
      facts['conceded_a_goal'] = over(opponent_goals, 0.5)
      facts['failed_to_score'] = under(team_goals, 0.5)
      facts['clean_sheet'] = under(opponent_goals, 0.5)
      facts['both_teams_score'] = btts_yes(team_goals, opponent_goals)
      facts['both_teams_do_not_score'] = btts_no(team_goals, opponent_goals)
      # Result & BTTS
      facts['win_to_nil'] = double_event_happened(facts['win'], facts['clean_sheet'])
      facts['win_and_both_teams_score'] = double_event_happened(facts['win'], facts['both_teams_score'])
      facts['loss_to_nil'] = double_event_happened(facts['loss'], facts['failed_to_score'])
      facts['loss_and_both_teams_score'] = double_event_happened(facts['loss'], facts['both_teams_score'])
      # Total goals
      facts['total_goals_over_0_5'] = over(total_goals, 0.5)
      facts['total_goals_over_1_5'] = over(total_goals, 1.5)
      facts['total_goals_over_2_5'] = over(total_goals, 2.5)
      facts['total_goals_over_3_5'] = over(total_goals, 3.5)
      facts['total_goals_under_0_5'] = under(total_goals, 0.5)
      facts['total_goals_under_1_5'] = under(total_goals, 1.5)
      facts['total_goals_under_2_5'] = under(total_goals, 2.5)
      facts['total_goals_under_3_5'] = under(total_goals, 3.5)
      # Team goals
      facts['team_goals_over_0_5'] = over(team_goals, 0.5)
      facts['team_goals_over_1_5'] = over(team_goals, 1.5)
      facts['team_goals_over_2_5'] = over(team_goals, 2.5)
      facts['team_goals_over_3_5'] = over(team_goals, 3.5)
      facts['team_goals_under_0_5'] = under(team_goals, 0.5)
      facts['team_goals_under_1_5'] = under(team_goals, 1.5)
      facts['team_goals_under_2_5'] = under(team_goals, 2.5)
      facts['team_goals_under_3_5'] = under(team_goals, 3.5)
      # Opponent goals
      facts['opponent_goals_over_0_5'] = over(opponent_goals, 0.5)
      facts['opponent_goals_over_1_5'] = over(opponent_goals, 1.5)
      facts['opponent_goals_over_2_5'] = over(opponent_goals, 2.5)
      facts['opponent_goals_over_3_5'] = over(opponent_goals, 3.5)
      facts['opponent_goals_under_0_5'] = under(opponent_goals, 0.5)
      facts['opponent_goals_under_1_5'] = under(opponent_goals, 1.5)
      facts['opponent_goals_under_2_5'] = under(opponent_goals, 2.5)
      facts['opponent_goals_under_3_5'] = under(opponent_goals, 3.5)
      # Result & total goals
      facts['win_and_total_goals_over_1_5'] = double_event_happened(facts['win'], facts['total_goals_over_1_5'])
      facts['win_and_total_goals_over_2_5'] = double_event_happened(facts['win'], facts['total_goals_over_2_5'])
      facts['win_and_total_goals_over_3_5'] = double_event_happened(facts['win'], facts['total_goals_over_3_5'])
      facts['win_and_total_goals_under_1_5'] = double_event_happened(facts['win'], facts['total_goals_under_1_5'])
      facts['win_and_total_goals_under_2_5'] = double_event_happened(facts['win'], facts['total_goals_under_2_5'])
      facts['win_and_total_goals_under_3_5'] = double_event_happened(facts['win'], facts['total_goals_under_3_5'])
      facts['draw_and_total_goals_over_1_5'] = double_event_happened(facts['draw'], facts['total_goals_over_1_5'])
      facts['draw_and_total_goals_over_2_5'] = double_event_happened(facts['draw'], facts['total_goals_over_2_5'])
      facts['draw_and_total_goals_over_3_5'] = double_event_happened(facts['draw'], facts['total_goals_over_3_5'])
      facts['draw_and_total_goals_under_1_5'] = double_event_happened(facts['draw'], facts['total_goals_under_1_5'])
      facts['draw_and_total_goals_under_2_5'] = double_event_happened(facts['draw'], facts['total_goals_under_2_5'])
      facts['draw_and_total_goals_under_3_5'] = double_event_happened(facts['draw'], facts['total_goals_under_3_5'])
      facts['loss_and_total_goals_over_1_5'] = double_event_happened(facts['loss'], facts['total_goals_over_1_5'])
      facts['loss_and_total_goals_over_2_5'] = double_event_happened(facts['loss'], facts['total_goals_over_2_5'])
      facts['loss_and_total_goals_over_3_5'] = double_event_happened(facts['loss'], facts['total_goals_over_3_5'])
      facts['loss_and_total_goals_under_1_5'] = double_event_happened(facts['loss'], facts['total_goals_under_1_5'])
      facts['loss_and_total_goals_under_2_5'] = double_event_happened(facts['loss'], facts['total_goals_under_2_5'])
      facts['loss_and_total_goals_under_3_5'] = double_event_happened(facts['loss'], facts['total_goals_under_3_5'])
      # Handicaps
      facts['win_by_2_goals_or_more'] = goals_margin(team_goals, opponent_goals, 2)
      facts['win_by_3_goals_or_more'] = goals_margin(team_goals, opponent_goals, 3)
      facts['loss_by_2_goals_or_more'] = goals_margin(opponent_goals, team_goals, 2)
      facts['loss_by_3_goals_or_more'] = goals_margin(opponent_goals, team_goals, 3)
      # corners
      facts['win_corners'] = win(team_corners, opponent_corners)
      facts['draw_corners'] = draw(team_corners, opponent_corners)
      facts['loss_corners'] = loss(team_corners, opponent_corners)
      # total corners
      facts['total_corners_under_1_5'] = under(total_corners, 1.5)
      facts['total_corners_under_2_5'] = under(total_corners, 2.5)
      facts['total_corners_under_3_5'] = under(total_corners, 3.5)
      facts['total_corners_under_4_5'] = under(total_corners, 4.5)
      facts['total_corners_under_5_5'] = under(total_corners, 5.5)
      facts['total_corners_under_8_5'] = under(total_corners, 8.5)
      facts['total_corners_under_9_5'] = under(total_corners, 9.5)
      facts['total_corners_under_10_5'] = under(total_corners, 10.5)
      facts['total_corners_under_11_5'] = under(total_corners, 11.5)
      facts['total_corners_under_12_5'] = under(total_corners, 12.5)
      facts['total_corners_over_1_5'] = over(total_corners, 1.5)
      facts['total_corners_over_2_5'] = over(total_corners, 2.5)
      facts['total_corners_over_3_5'] = over(total_corners, 3.5)
      facts['total_corners_over_4_5'] = over(total_corners, 4.5)
      facts['total_corners_over_5_5'] = over(total_corners, 5.5)
      facts['total_corners_over_8_5'] = over(total_corners, 8.5)
      facts['total_corners_over_9_5'] = over(total_corners, 9.5)
      facts['total_corners_over_10_5'] = over(total_corners, 10.5)
      facts['total_corners_over_11_5'] = over(total_corners, 11.5)
      facts['total_corners_over_12_5'] = over(total_corners, 12.5)
      # team corners
      facts['team_corners_under_1_5'] = under(team_corners, 1.5)
      facts['team_corners_under_2_5'] = under(team_corners, 2.5)
      facts['team_corners_under_3_5'] = under(team_corners, 3.5)
      facts['team_corners_under_4_5'] = under(team_corners, 4.5)
      facts['team_corners_under_5_5'] = under(team_corners, 5.5)
      facts['team_corners_under_6_5'] = under(team_corners, 6.5)
      facts['team_corners_under_7_5'] = under(team_corners, 7.5)
      facts['team_corners_under_8_5'] = under(team_corners, 8.5)
      facts['team_corners_over_1_5'] = over(team_corners, 4.5)
      facts['team_corners_over_2_5'] = over(team_corners, 4.5)
      facts['team_corners_over_3_5'] = over(team_corners, 4.5)
      facts['team_corners_over_4_5'] = over(team_corners, 4.5)
      facts['team_corners_over_5_5'] = over(team_corners, 5.5)
      facts['team_corners_over_6_5'] = over(team_corners, 6.5)
      facts['team_corners_over_7_5'] = over(team_corners, 7.5)
      facts['team_corners_over_8_5'] = over(team_corners, 8.5)
      # opponent corners
      facts['opponent_corners_under_1_5'] = under(opponent_corners, 1.5)
      facts['opponent_corners_under_2_5'] = under(opponent_corners, 2.5)
      facts['opponent_corners_under_3_5'] = under(opponent_corners, 3.5)
      facts['opponent_corners_under_4_5'] = under(opponent_corners, 4.5)
      facts['opponent_corners_under_5_5'] = under(opponent_corners, 5.5)
      facts['opponent_corners_under_6_5'] = under(opponent_corners, 6.5)
      facts['opponent_corners_under_7_5'] = under(opponent_corners, 7.5)
      facts['opponent_corners_under_8_5'] = under(opponent_corners, 8.5)
      facts['opponent_corners_over_1_5'] = over(opponent_corners, 1.5)
      facts['opponent_corners_over_2_5'] = over(opponent_corners, 2.5)
      facts['opponent_corners_over_3_5'] = over(opponent_corners, 3.5)
      facts['opponent_corners_over_4_5'] = over(opponent_corners, 4.5)
      facts['opponent_corners_over_5_5'] = over(opponent_corners, 5.5)
      facts['opponent_corners_over_6_5'] = over(opponent_corners, 6.5)
      facts['opponent_corners_over_7_5'] = over(opponent_corners, 7.5)
      facts['opponent_corners_over_8_5'] = over(opponent_corners, 8.5)
      # total yellow cards
      facts['total_yellow_cards_under_2_5'] = under(total_yellow_cards, 2.5)
      facts['total_yellow_cards_under_3_5'] = under(total_yellow_cards, 3.5)
      facts['total_yellow_cards_under_4_5'] = under(total_yellow_cards, 4.5)
      facts['total_yellow_cards_under_5_5'] = under(total_yellow_cards, 5.5)
      facts['total_yellow_cards_over_2_5'] = over(total_yellow_cards, 2.5)
      facts['total_yellow_cards_over_3_5'] = over(total_yellow_cards, 3.5)
      facts['total_yellow_cards_over_4_5'] = over(total_yellow_cards, 4.5)
      facts['total_yellow_cards_over_5_5'] = over(total_yellow_cards, 5.5)
      # team yellow cards
      facts['team_yellow_cards_under_0_5'] = under(team_yellow_cards, 0.5)
      facts['team_yellow_cards_under_1_5'] = under(team_yellow_cards, 1.5)
      facts['team_yellow_cards_under_2_5'] = under(team_yellow_cards, 2.5)
      facts['team_yellow_cards_under_3_5'] = under(team_yellow_cards, 3.5)
      facts['team_yellow_cards_over_0_5'] = over(team_yellow_cards, 0.5)
      facts['team_yellow_cards_over_1_5'] = over(team_yellow_cards, 1.5)
      facts['team_yellow_cards_over_2_5'] = over(team_yellow_cards, 2.5)
      facts['team_yellow_cards_over_3_5'] = over(team_yellow_cards, 3.5)
      # opponent yellow cards
      facts['opponent_yellow_cards_under_0_5'] = under(opponent_yellow_cards, 0.5)
      facts['opponent_yellow_cards_under_1_5'] = under(opponent_yellow_cards, 1.5)
      facts['opponent_yellow_cards_under_2_5'] = under(opponent_yellow_cards, 2.5)
      facts['opponent_yellow_cards_under_3_5'] = under(opponent_yellow_cards, 3.5)
      facts['opponent_yellow_cards_over_0_5'] = over(opponent_yellow_cards, 0.5)
      facts['opponent_yellow_cards_over_1_5'] = over(opponent_yellow_cards, 1.5)
      facts['opponent_yellow_cards_over_2_5'] = over(opponent_yellow_cards, 2.5)
      facts['opponent_yellow_cards_over_3_5'] = over(opponent_yellow_cards, 3.5)
      # total red cards
      facts['total_red_cards_under_0_5'] = under(total_red_cards, 0.5)
      facts['total_red_cards_over_0_5'] = under(total_red_cards, 0.5)
      facts.transform_keys{ |k| "#{k}_#{period}" }
    end

    def win(team_stat, opponent_stat)
      team_stat > opponent_stat ? 1 : 0
    end
  
    def draw(team_stat, opponent_stat)
      team_stat == opponent_stat ? 1 : 0
    end
  
    def loss(team_stat, opponent_stat)
      team_stat < opponent_stat ? 1 : 0
    end
  
    def no_win(team_stat, opponent_stat)
      team_stat <= opponent_stat ? 1 : 0
    end
  
    def no_draw(team_stat, opponent_stat)
      team_stat == opponent_stat ? 0 : 1
    end
  
    def no_loss(team_stat, opponent_stat)
      team_stat >= opponent_stat ? 1 : 0
    end
  
    def ht_ft(half_time, full_time)
      half_time == 1 && full_time == 1 ? 1 : 0
    end
  
    def over(stat, total)
      stat > total ? 1 : 0
    end
  
    def under(stat, total)
      stat < total ? 1 : 0
    end
  
    def btts_yes(team_stat, opponent_stat)
      team_stat.positive? && opponent_stat.positive? ? 1 : 0
    end
  
    def btts_no(team_stat, opponent_stat)
      team_stat < 1 || opponent_stat < 1 ? 1 : 0
    end
  
    def double_event_happened(first_event, second_event)
      first_event == 1 && second_event == 1 ? 1 : 0
    end
  
    def goals_margin(goals_scored, goals_conceded, margin)
      goals_scored - goals_conceded >= margin ? 1 : 0
    end
  
    def correct_score(home_goals, away_goals)
      goals_hash = {
        "0-0": 0, "1-1": 0, "2-2": 0, "3-3": 0,
        "1-0": 0, "2-0": 0, "2-1": 0, "3-0": 0, "3-1": 0, "3-2": 0,
        "0-1": 0, "0-2": 0, "1-2": 0, "0-3": 0, "1-3": 0, "2-3": 0, any: 0
      }
      score = "#{home_goals}-#{away_goals}".to_sym
      if goals_hash.key?(score)
        goals_hash[score] = 1
      else
        goals_hash[:any] = 1
      end
      goals_hash
    end
end