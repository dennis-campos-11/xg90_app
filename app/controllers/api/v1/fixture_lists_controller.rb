class Api::V1::FixtureListsController < ApplicationController
  helper ProcessedDataHelper

  before_action :authorize_request
  before_action :set_fixture_list, only: [:show, :update]

  def index
    @fixture_lists = FixtureList.all
  end

  def search
    @fixture_list = FixtureList.includes(:fixture_list_competitions, fixture_list_fields: :data_field).new(fixture_list_params)
    render_search
  end

  def show
    render_search
  end

  def create
    @fixture_list = FixtureList.new(fixture_list_params)
    if @fixture_list.save
      render partial: "api/v1/fixture_lists/fixture_list", 
            json: { 
              success: true, 
              fixture_list: @fixture_list, 
              message: "Fixture list was created successfully." 
            }, 
            status: :ok
    else
      render json: { success: false, errors: @fixture_list.errors, message: "We were unable to create your fixture list." }, status: :unprocessable_entity
    end
  end

  def update
    if @fixture_list.update(fixture_list_params)
      render partial: "api/v1/fixture_lists/fixture_list", 
            json: { 
            success: true, 
              fixture_list: @fixture_list, 
              message: "Fixture list was updated successfully." 
            }, 
            status: :ok
    else
      render json: { success: false, errors: @fixture_list.errors, message: "We were unable to update your fixture list." }, status: :unprocessable_entity
    end
  end

  def meta
    render json: FixtureLists::MetaService.new.call
  end

  private

  def set_fixture_list
    @fixture_list = FixtureList.includes(:fixture_list_competitions, fixture_list_fields: :data_field)
                               .find(params[:id])
  end

  def fixture_list_params
    params.require(:fixture_list).permit(
      :id, :name, :home_location, :away_location, :sample, 
      :only_current_competition, :show_variance_against_competition,
      fixture_list_fields_attributes: [:id, :data_field_id, :index, :_destroy, filters: {}],
      fixture_list_competitions_attributes: [:id, :competition_id, :_destroy],
    )
  end

  def render_search
    prepare_search_fields
    @grouped_fixtures = FixtureListSearch.call(fixture_list: @fixture_list)
    render template: 'api/v1/fixture_lists/search'
  end

  def prepare_search_fields
    fields = @fixture_list.preload_data_fields!

    @allowed_stats = fields.select { |f| f.data_field&.statistic? }.map { |f| f.data_field.code }
    @allowed_facts = fields.select { |f| f.data_field&.fact? }.map { |f| f.data_field.code }
  end
end

