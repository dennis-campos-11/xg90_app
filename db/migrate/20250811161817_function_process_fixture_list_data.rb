class FunctionProcessFixtureListData < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION process_fixture_list_data(params JSONB)
      RETURNS TABLE (
        team_id INT,
        fixture_id INT,
        team_location INT,
        processed_stats JSONB,
        processed_facts JSONB
      ) AS $$
      WITH single_fixture_list AS (
        SELECT
          params->>'id' AS id,
          params->>'name' AS name,
          (params->>'total_matches')::int AS total_matches,
          (params->>'season_index')::int AS season_index,
          (params->>'home_location')::int AS home_location,
          (params->>'away_location')::int AS away_location,
          (params->>'only_current_competition')::boolean AS only_current_competition,
          COALESCE(params->'fixture_list_fields_attributes', params->'fixture_list_fields') AS fixture_list_fields
      ),
      total_matches_value AS (
        SELECT total_matches FROM single_fixture_list
      ),
      upcoming_fixtures AS (
        SELECT id, starting_at, home_id, away_id, competition_id
        FROM fixtures
        WHERE starting_at >= now()
          AND starting_at < now() + interval '4 days'
      ),
      input_teams AS (
        SELECT DISTINCT
          f.home_id AS team_id,
          1 AS team_location,
          sfl.home_location AS data_location,
          f.id AS fixture_id,
          f.competition_id
        FROM upcoming_fixtures f
        CROSS JOIN single_fixture_list sfl

        UNION

        SELECT DISTINCT
          f.away_id AS team_id,
          2 AS team_location,
          sfl.away_location AS data_location,
          f.id AS fixture_id,
          f.competition_id
        FROM upcoming_fixtures f
        CROSS JOIN single_fixture_list sfl
      ),
      fields AS (
        SELECT
          COALESCE(fl->>'field_code', df.code) AS field_code,
          COALESCE((fl->>'field_type')::NUMERIC, df.field_type) AS field_type,
          (fl->>'filters')::JSONB AS filters
        FROM single_fixture_list sfl
        CROSS JOIN LATERAL jsonb_array_elements(
          sfl.fixture_list_fields ||
          '[{"field_code":"minutes_on_field_ft","field_type":1,"filters":{}},
            {"field_code":"minutes_on_field_1h","field_type":1,"filters":{}},
            {"field_code":"minutes_on_field_2h","field_type":1,"filters":{}}]'::jsonb
        ) AS fl
        LEFT JOIN data_fields df
          ON df.id = (fl->>'data_field_id')::INT
          OR df.code = fl->>'field_code'
      ),
      recent_fixtures AS (
        SELECT
          t.team_id,
          t.team_location,
          t.fixture_id,
          f.starting_at,
          CASE WHEN t.team_id = f.home_id THEN f.home_stats ELSE f.away_stats END AS stats,
          CASE WHEN t.team_id = f.home_id THEN f.home_facts ELSE f.away_facts END AS facts,
          CASE WHEN t.team_id = f.home_id THEN f.away_stats ELSE f.home_stats END AS opponent_stats,
          CASE WHEN t.team_id = f.home_id THEN f.away_facts ELSE f.home_facts END AS opponent_facts,
          CASE WHEN t.team_id = f.home_id THEN 'home' ELSE 'away' END AS location,
          CASE WHEN t.team_id = f.home_id THEN f.away_id ELSE f.home_id END AS opponent_id,
          opponent.name AS opponent_name
        FROM input_teams t
        JOIN LATERAL (
          SELECT fi.*
          FROM fixtures fi
          JOIN seasons s ON fi.season_id = s.id
          CROSS JOIN single_fixture_list sfl
          WHERE
            (
              sfl.season_index IS NULL
              OR s.index <= sfl.season_index
            )
            AND fi.status = 1
            AND t.team_id IN (fi.home_id, fi.away_id)
            AND t.team_id = CASE
              WHEN t.data_location = 1 THEN fi.home_id
              WHEN t.data_location = 2 THEN fi.away_id
              ELSE t.team_id
            END
            AND t.competition_id = CASE
              WHEN sfl.only_current_competition IS TRUE THEN fi.competition_id
              ELSE t.competition_id
            END
          ORDER BY fi.starting_at DESC
          LIMIT (SELECT total_matches FROM total_matches_value)
        ) f ON true
        JOIN teams opponent ON opponent.id = CASE WHEN t.team_id = f.home_id THEN f.away_id ELSE f.home_id END
      ),
      stats_agg AS (
        SELECT
          rf.team_id,
          rf.team_location,
          rf.fixture_id,
          fields.field_code,
          COUNT(*) AS games_played,
          ROUND(AVG((rf.stats ->> fields.field_code)::NUMERIC), 2) AS average,
          ROUND(SUM((rf.stats ->> fields.field_code)::NUMERIC), 2) AS total,
          ROUND((
            SUM((rf.stats ->> fields.field_code)::NUMERIC) /
            (
              SUM((rf.stats ->> ('minutes_on_field_' || RIGHT(fields.field_code, 2)))::NUMERIC) /
              CASE
                WHEN RIGHT(fields.field_code, 2) = 'ft' THEN 90.0
                WHEN RIGHT(fields.field_code, 2) IN ('1h', '2h') THEN 45.0
                ELSE 1.0
              END
            )
          ), 2) AS average_by_period,
          JSONB_AGG(
            JSONB_BUILD_OBJECT(
              'fixture_id', rf.fixture_id,
              'opponent_id', rf.opponent_id,
              'opponent_name', rf.opponent_name,
              'location', rf.location,
              'value', ROUND((rf.stats ->> fields.field_code)::NUMERIC, 2)::FLOAT8,
              'opponent_value', ROUND((rf.opponent_stats ->> fields.field_code)::NUMERIC, 2)::FLOAT8
            ) ORDER BY rf.starting_at
          ) AS history
        FROM recent_fixtures rf
        JOIN fields ON fields.field_code = fields.field_code AND fields.field_type = 1
        WHERE fields.field_type = 1
        GROUP BY rf.team_id, rf.team_location, rf.fixture_id, fields.field_code
      ),
      stats_agg_extras AS (
        SELECT
          s.fixture_id,
          s.field_code,
          ROUND(SUM(average), 2) AS overall,
          ROUND(SUM(average_by_period), 2) AS overall_by_period
        FROM stats_agg s
        WHERE s.fixture_id IS NOT NULL
        GROUP BY s.fixture_id, s.field_code
      ),
      filtered_stats AS (
        SELECT stats_agg.*, se.overall, se.overall_by_period
        FROM stats_agg
        JOIN stats_agg_extras se ON se.fixture_id = stats_agg.fixture_id AND stats_agg.field_code = se.field_code
        LEFT JOIN fields ON stats_agg.field_code = fields.field_code AND fields.field_type = 1
        WHERE
          se.overall BETWEEN COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'overall'->'home'->>'from', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'overall'->'away'->>'from', '')::NUMERIC ELSE NULL END, 0)
          AND COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'overall'->'home'->>'to', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'overall'->'away'->>'to', '')::NUMERIC ELSE NULL END, 'infinity')
          AND se.overall_by_period BETWEEN COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'overall_by_period'->'home'->>'from', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'overall_by_period'->'away'->>'from', '')::NUMERIC ELSE NULL END, 0)
          AND COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'overall_by_period'->'home'->>'to', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'overall_by_period'->'away'->>'to', '')::NUMERIC ELSE NULL END, 'infinity')
          AND stats_agg.average BETWEEN COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'average'->'home'->>'from', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'average'->'away'->>'from', '')::NUMERIC ELSE NULL END, 0)
          AND COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'average'->'home'->>'to', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'average'->'away'->>'to', '')::NUMERIC ELSE NULL END, 'infinity')
          AND stats_agg.average_by_period BETWEEN COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'average_by_period'->'home'->>'from', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'average_by_period'->'away'->>'from', '')::NUMERIC ELSE NULL END, 0)
          AND COALESCE(CASE stats_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'average_by_period'->'home'->>'to', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'average_by_period'->'away'->>'to', '')::NUMERIC ELSE NULL END, 'infinity')
      ),
      facts_agg AS (
        SELECT
          rf.team_id,
          rf.team_location,
          rf.fixture_id,
          fields.field_code,
          COUNT(*) AS games_played,
          SUM((rf.facts ->> fields.field_code)::NUMERIC) AS total,
          ROUND(AVG((rf.facts ->> fields.field_code)::NUMERIC * 100), 0) AS percentage,
          COALESCE(
            ARRAY_POSITION(
              ARRAY_APPEND(ARRAY_AGG((rf.facts ->> fields.field_code)::int ORDER BY rf.starting_at ASC), 0),
              0
            ) - 1, 0
          ) AS streak,
          JSONB_AGG(
            JSONB_BUILD_OBJECT(
              'fixture_id', rf.fixture_id,
              'opponent_id', rf.opponent_id,
              'opponent_name', rf.opponent_name,
              'location', rf.location,
              'value', ROUND((rf.facts ->> fields.field_code)::NUMERIC, 2)::FLOAT8,
              'opponent_value', ROUND((rf.opponent_facts ->> fields.field_code)::NUMERIC, 2)::FLOAT8
            ) ORDER BY rf.starting_at
          ) AS history
        FROM recent_fixtures rf
        JOIN fields ON fields.field_code = fields.field_code AND fields.field_type = 2
        WHERE fields.field_type = 2
        GROUP BY rf.team_id, rf.team_location, rf.fixture_id, fields.field_code
      ),
      facts_agg_extras AS (
        SELECT
          f.fixture_id,
          f.field_code,
          ROUND(AVG(percentage), 2) AS average
        FROM facts_agg f
        WHERE f.fixture_id IS NOT NULL
        GROUP BY f.fixture_id, f.field_code
      ),
      filtered_facts AS (
        SELECT facts_agg.*, fe.average
        FROM facts_agg
        JOIN facts_agg_extras fe ON fe.fixture_id = facts_agg.fixture_id AND facts_agg.field_code = fe.field_code
        LEFT JOIN fields ON facts_agg.field_code = fields.field_code AND fields.field_type = 2
        WHERE
          facts_agg.percentage BETWEEN COALESCE(CASE facts_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'percentage'->'home'->>'from', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'percentage'->'away'->>'from', '')::NUMERIC ELSE NULL END, 0)
          AND COALESCE(CASE facts_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'percentage'->'home'->>'to', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'percentage'->'away'->>'to', '')::NUMERIC ELSE NULL END, 'infinity')
          AND facts_agg.total BETWEEN COALESCE(CASE facts_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'total'->'home'->>'from', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'total'->'away'->>'from', '')::NUMERIC ELSE NULL END, 0)
          AND COALESCE(CASE facts_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'total'->'home'->>'to', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'total'->'away'->>'to', '')::NUMERIC ELSE NULL END, 'infinity')
          AND facts_agg.streak BETWEEN COALESCE(CASE facts_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'streak'->'home'->>'from', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'streak'->'away'->>'from', '')::NUMERIC ELSE NULL END, 0)
          AND COALESCE(CASE facts_agg.team_location WHEN 1 THEN NULLIF(fields.filters->'streak'->'home'->>'to', '')::NUMERIC WHEN 2 THEN NULLIF(fields.filters->'streak'->'away'->>'to', '')::NUMERIC ELSE NULL END, 'infinity')
      ),
      field_count AS (
        SELECT COUNT(DISTINCT field_code) AS total_fields FROM fields
      ),
      final_data AS (
        SELECT
          t.team_id,
          t.fixture_id,
          COALESCE(s.team_location, f.team_location) AS team_location,
          JSONB_AGG(DISTINCT JSONB_BUILD_OBJECT(
            'field_code', s.field_code,
            'games_played', s.games_played,
            'overall', s.overall::FLOAT8,
            'overall_by_period', s.overall_by_period::FLOAT8,
            'total', s.total::FLOAT8,
            'average', s.average::FLOAT8,
            'average_by_period', s.average_by_period::FLOAT8,
            'history', s.history
          )) AS processed_stats,
          JSONB_AGG(DISTINCT JSONB_BUILD_OBJECT(
            'field_code', f.field_code,
            'games_played', f.games_played,
            'average', f.average::FLOAT8,
            'total', f.total::FLOAT8,
            'percentage', f.percentage::FLOAT8,
            'streak', f.streak::FLOAT8,
            'history', f.history
          )) AS processed_facts
        FROM input_teams t
        LEFT JOIN filtered_stats s ON s.team_id = t.team_id AND s.field_code IS NOT NULL
        LEFT JOIN filtered_facts f ON f.team_id = t.team_id AND f.field_code IS NOT NULL
        GROUP BY t.fixture_id, t.team_id, s.team_location, f.team_location
        HAVING 
          (COUNT(DISTINCT s.field_code) + COUNT(DISTINCT f.field_code)) = (SELECT total_fields FROM field_count)
      )
      SELECT *
      FROM final_data
      WHERE fixture_id IN (
        SELECT fixture_id
        FROM final_data
        GROUP BY fixture_id
        HAVING COUNT(DISTINCT team_location) = 2
      );
      $$ LANGUAGE SQL STABLE;
    SQL
  end

  def down
    execute <<-SQL
      DROP FUNCTION IF EXISTS process_fixture_list_data(JSONB);
    SQL
  end
end
