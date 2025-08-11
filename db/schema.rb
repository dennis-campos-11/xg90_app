# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_11_193804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.bigint "external_ws_id"
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_competitions_on_country_id"
    t.index ["external_ws_id"], name: "index_competitions_on_external_ws_id", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.bigint "external_ws_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_ws_id"], name: "index_countries_on_external_ws_id", unique: true
  end

  create_table "data_fields", force: :cascade do |t|
    t.string "code"
    t.integer "field_type"
    t.integer "half_type"
    t.jsonb "settings", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code", "field_type"], name: "idx_data_fields_code_type"
  end

  create_table "fixture_list_competitions", force: :cascade do |t|
    t.bigint "fixture_list_id", null: false
    t.bigint "competition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "idx_fixture_list_fields_competition_id"
    t.index ["competition_id"], name: "index_fixture_list_competitions_on_competition_id"
    t.index ["fixture_list_id", "competition_id"], name: "idx_on_fixture_list_id_competition_id_7e158515e7", unique: true
    t.index ["fixture_list_id"], name: "index_fixture_list_competitions_on_fixture_list_id"
  end

  create_table "fixture_list_fields", force: :cascade do |t|
    t.bigint "fixture_list_id", null: false
    t.bigint "data_field_id", null: false
    t.jsonb "filters", default: {}
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_field_id"], name: "idx_fixture_list_fields_data_field_id"
    t.index ["data_field_id"], name: "index_fixture_list_fields_on_data_field_id"
    t.index ["fixture_list_id", "data_field_id"], name: "index_fixture_list_fields_on_fixture_list_id_and_data_field_id", unique: true
    t.index ["fixture_list_id"], name: "index_fixture_list_fields_on_fixture_list_id"
  end

  create_table "fixture_lists", force: :cascade do |t|
    t.string "name"
    t.integer "home_location"
    t.integer "away_location"
    t.integer "total_matches"
    t.integer "season_index"
    t.boolean "only_current_competition", default: false
    t.boolean "show_variance_against_competition", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fixtures", force: :cascade do |t|
    t.bigint "competition_id"
    t.bigint "season_id"
    t.bigint "home_id"
    t.bigint "away_id"
    t.bigint "external_ws_id"
    t.datetime "starting_at"
    t.integer "status"
    t.jsonb "home_stats", default: {}
    t.jsonb "away_stats", default: {}
    t.jsonb "home_facts", default: {}
    t.jsonb "away_facts", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["away_id", "starting_at"], name: "idx_fixtures_away_id_starting_at"
    t.index ["away_id"], name: "index_fixtures_on_away_id"
    t.index ["competition_id", "starting_at"], name: "idx_fixtures_competition_id_starting_at"
    t.index ["competition_id"], name: "index_fixtures_on_competition_id"
    t.index ["external_ws_id"], name: "index_fixtures_on_external_ws_id", unique: true
    t.index ["home_id", "starting_at"], name: "idx_fixtures_home_id_starting_at"
    t.index ["home_id"], name: "index_fixtures_on_home_id"
    t.index ["season_id"], name: "index_fixtures_on_season_id"
    t.index ["starting_at"], name: "idx_fixtures_starting_at"
  end

  create_table "season_teams", force: :cascade do |t|
    t.bigint "season_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season_id", "team_id"], name: "index_season_teams_on_season_id_and_team_id", unique: true
    t.index ["season_id"], name: "index_season_teams_on_season_id"
    t.index ["team_id"], name: "index_season_teams_on_team_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.string "name"
    t.bigint "external_ws_id"
    t.bigint "competition_id", null: false
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_seasons_on_competition_id"
    t.index ["external_ws_id"], name: "index_seasons_on_external_ws_id", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.bigint "external_ws_id"
    t.string "primary_color"
    t.string "text_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_ws_id"], name: "index_teams_on_external_ws_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "language", default: "en"
    t.string "appearance", default: "light"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_foreign_key "competitions", "countries"
  add_foreign_key "fixture_list_competitions", "competitions"
  add_foreign_key "fixture_list_competitions", "fixture_lists"
  add_foreign_key "fixture_list_fields", "data_fields"
  add_foreign_key "fixture_list_fields", "fixture_lists"
  add_foreign_key "fixtures", "competitions"
  add_foreign_key "fixtures", "seasons"
  add_foreign_key "fixtures", "teams", column: "away_id"
  add_foreign_key "fixtures", "teams", column: "home_id"
  add_foreign_key "season_teams", "seasons"
  add_foreign_key "season_teams", "teams"
  add_foreign_key "seasons", "competitions"
end
