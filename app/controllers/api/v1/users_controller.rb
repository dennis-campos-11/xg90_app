class Api::V1::UsersController < ApplicationController
  before_action :authorize_request

  def me
    render json: { user: @current_user.slice(:id, :email, :first_name, :last_name, :language, :appearance) }
  end
end